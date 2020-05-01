--[[
    @Author: supercombo519 
    @Date: 2020-03-20 11:16:10 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 11:16:10 
]]

require("class.Cls")
require("table.table")
require("behaviortree.Parser")

BTree = Cls("BTree")

BTreeEnum = {}

BTreeEnum.Status = {
    Running = 1,
    Success = 2,
    Failure = 3,
    Ready = 4,
}

BTreeEnum.Type = {
    Action = 1,
    Composite = 2,
    Condition = 3,
    Decorator = 4,
}

function BTree:initialize(treeConf)
    --[[
        {
            --自身打断
            selfInterrupt = {},
            --打断低优先级
            lowPriorityInterrupt = {},
        }
    ]]
    self._interruptNodes = nil;
    self._status = nil;
    self._bindingObject = nil;
    self._root = Parser:getInstance():run(treeConf, self);
end

function BTree:update(dt)
    --查看一下打断了吗 打断的话清除running
    if self._status == BTreeEnum.Status.Running and self:__isHaveInterruptNode() then 
        local actions = self:__getRunningActions();
        if self:__isInterrupt(actions) == true then 
            self:__breakCurRunningNode();
        end 
    end
    self._status = self._root:update(dt)
end

function BTree:setBindingObject(bindingObject)
    self._bindingObject = bindingObject;
end

function BTree:getBindingObject()
    return self._bindingObject;
end

--打断正在 running 的node
function BTree:__breakCurRunningNode()
    --遍历 把所有的 child status 置空
    local func = function (node)
        node:setStatus(BTreeEnum.Status.Ready);
    end
    self:__traversalNodeWithFunc(self._root, func)
end

--找正在运行中的 aciton 节点 或 decorator 节点
function BTree:__getRunningActions()
    local outRet = {};
    
    local func = function (node)
        local status = node:getStatus();
        local nodeType = node:getType();
        if status == BTreeEnum.Status.Running and (nodeType == BTreeEnum.Type.Action or nodeType == BTreeEnum.Type.Decorator) then 
            table.insert(outRet, node);
        end 
    end

    self:__traversalNodeWithFunc(self._root, func)
    return outRet;
end

--[[
    func 是遍历到的 node
]]
function BTree:__traversalNodeWithFunc(node, func)
    local nodeType = node:getType();
    -- assert(func, "没有传入func")
    func(node);
    if nodeType == BTreeEnum.Type.Decorator then 
        local child = node:getChild();
        self:__traversalNodeWithFunc(child, func);
    elseif nodeType == BTreeEnum.Type.Composite then 
        local children = node:getChildren();
        for i, v in ipairs(children) do
            self:__traversalNodeWithFunc(v, func);
        end
    end 
end

function BTree:__getSelfInterruptNodes( )
    if self._interruptNodes == nil then 
        return nil;
    end 
    return self._interruptNodes.selfInterrupt;
end

function BTree:__getLowInterruptInterruptNodes( )
    if self._interruptNodes == nil then 
        return nil;
    end 
    return self._interruptNodes.lowPriorityInterrupt;
end

function BTree:__isHaveInterruptNode()
    if self._interruptNodes == nil then 
        return false;
    end 

    local isHaveSelfInterruptNode = self:__isHaveSelfInterruptNode();
    local isHaveLowPriorityInterruptNode = self:__isHaveLowPriorityInterruptNode();

    if isHaveSelfInterruptNode or isHaveLowPriorityInterruptNode then 
        return true;
    else 
        return false;
    end 
end

function BTree:__isHaveLowPriorityInterruptNode()
    if self._interruptNodes == nil then 
        return false;
    end 

    local nodes = self:__getLowInterruptInterruptNodes();
    if nodes and table.length(nodes) > 0 then 
        return true;
    else 
        return false;
    end 
end

function BTree:__isHaveSelfInterruptNode()
    if self._interruptNodes == nil then 
        return false;
    end 

    local nodes = self:__getSelfInterruptNodes();
    if nodes and table.length(nodes) > 0 then 
        return true;
    else 
        return false;
    end 
end

function BTree:addSelfInterruptNode(node)
    if self._interruptNodes == nil then 
        self._interruptNodes = {};
    end 
    if self._interruptNodes.selfInterrupt == nil then 
        self._interruptNodes.selfInterrupt = {};
    end 

    table.insert(self._interruptNodes.selfInterrupt, node);
end

function BTree:addLowPriorityInterruptNode(node)
    if self._interruptNodes == nil then 
        self._interruptNodes = {};
    end 
    if self._interruptNodes.lowPriorityInterrupt == nil then 
        self._interruptNodes.lowPriorityInterrupt = {};
    end 

    table.insert(self._interruptNodes.lowPriorityInterrupt, node);
end

--打断否 
function BTree:__isInterrupt(runningAcitions)
    --先看selfInterrupt的 
    local selfInterrupt = self:__checkSelfInterrupt();
    --再看低优先级打断
    local lowProrityInterrupt = self:__checkLowProrityInterrupt(runningAcitions);
    if selfInterrupt or lowProrityInterrupt then 
        return true;
    else 
        return false;
    end 
end

function BTree:__checkSelfInterrupt()
    local ret = false;
    if self:__isHaveSelfInterruptNode() == true then
        --若我在running 看看我下面的 condition 和 decorator 是不是都是success
        local nodes = self:__getSelfInterruptNodes();
        for k, v in pairs(nodes) do
            local state = v:getStatus();
            --看看我是不是running
            if state == BTreeEnum.Status.Running then 
                --状态是 BTreeEnum.Status.Failure
                local drillState = v:checkConditions();
                if drillState == BTreeEnum.Status.Failure then 
                    --滚了 滚了 打断
                    return true;
                end 
            end 
        end
    end 
    return ret;
end

function BTree:__checkLowProrityInterrupt(runningAcitions)
    local ret = false;
    if self:__isHaveLowPriorityInterruptNode() == true then
        local interruptNodes = self:__getLowInterruptInterruptNodes()

        for i, runningNode in ipairs(runningAcitions) do
            local runningIndex = runningNode:getTraversalIndex();
            --遍历打断条件
            for i, v in ipairs(interruptNodes) do
                local conditionIndex = v:getTraversalIndex();
                if v:isAncestor(runningNode) == false --running节点不是v的子节点
                        and conditionIndex < runningIndex -- condition在前面
                            and v:getStatus() ~= BTreeEnum.Status.Running --自己不是运行中
                                and v:checkConditions() == BTreeEnum.Status.Success then --返回成功
                    --滚了 滚了 打断
                    return true
                end 
            end
        end
    end
    return ret;
end





