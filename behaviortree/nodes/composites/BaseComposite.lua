--[[
    @Author: supercombo519 
    @Date: 2020-03-20 11:46:25 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 11:46:25 
]]
require("behaviortree.nodes.BTreeNode")


local super = BTreeNode
BaseComposite = Cls("BaseComposite", super)

function BaseComposite:initialize()
    super.initialize(self)
    self._children = {};
    --还在运行中的节点
    self._runningChildren = {};
    self._type = BTreeEnum.Type.Composite;
end

function BaseComposite:update()
    -- assert(false, "override me")
end

function BaseComposite:addChild(child)
    table.insert( self._children, child );
end

function BaseComposite:getChildren()
    return self._children;
end

function BaseComposite:setStatus(state)
    super.setStatus(self, state)
    --不是running状态 清理running状态
    if state ~= BTreeEnum.Status.Running then 
        self:clearRunningChildren();
    end 
end

--[[
    没有正在运行的
    或
    就是正在运行的
]]
function BaseComposite:checkIsNeedUpdate(child)
    local ret = false;
    if table.length(self._runningChildren) == 0 then 
        ret = true;
    else
        if child:getStatus() == BTreeEnum.Status.Running then 
            ret = true;
        else 
            ret = false
        end 
    end 
    return ret;
end

function BaseComposite:addRunningChild(child)
    self._runningChildren[child] = child;
end

function BaseComposite:removeRunningChild(child)
    self._runningChildren[child] = nil;
end

function BaseComposite:clearRunningChildren()
    for k, v in pairs(self._runningChildren) do
        v:reset();
    end
    table.clear(self._runningChildren);
end

function BaseComposite:isHaveRunningChildren( )
    if length(self._runningChildren) == 0 then 
        return false
    else 
        return true
    end 
end

--[[
    用于判断条件打断
    查看一圈我下面的condition和decorator，假设就有这些节点，我返回什么， 各个 composite 分开写

    nil 则不需要打断
]]
function BaseComposite:checkConditions()
    
end


