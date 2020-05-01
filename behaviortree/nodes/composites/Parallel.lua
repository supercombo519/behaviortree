--[[
    @Author: supercombo519 
    @Date: 2020-03-20 14:55:05 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 14:55:05 

    类似 sequence 不过是并行的 
]]
require("behaviortree.nodes.composites.BaseComposite")
local super = BaseComposite
Parallel = Cls("Parallel", super)

function Parallel:update(dt)
    --[[
        有没有 running node
        有  
            只执行runningnode 
        没有
            都执行一遍    
    ]]
    local isHaveRunningChildren = self:isHaveRunningChildren();
    local isFindFailureNode = false;
    for k, v in ipairs(self._children) do
        --其实没有执行中的 node 或 有runngingnoe 并且我是 runningnode
        if isHaveRunningChildren == false or self:checkIsNeedUpdate(v) then 
            local preStatus = v:getStatus();
            
            local status = v:update(dt);
            v:setStatus(status);
            if status == BTreeEnum.Status.Failure then 
                --找到 Failure 的节点了，也不 return，也需要继续遍历后续节点
                isFindFailureNode = true;
            elseif status == BTreeEnum.Status.Running then 
                self:addRunningChild(v);
            end
            
            --之前running的结束了，清除 runningChildren 好让后续node可以运行
            if preStatus == BTreeEnum.Status.Running and status ~= BTreeEnum.Status.Running then 
                self:removeRunningChild(v);
            end 
        end 
    end

    if isFindFailureNode then 
        self:clearRunningChildren();
        return status;
    else 
        if self:isHaveRunningChildren() == true then 
            return BTreeEnum.Status.Running;
        else 
            self:clearRunningChildren();
            return BTreeEnum.Status.Success;
        end 
    end 
end

function Parallel:checkConditions()
    --若没有条件节点则不需要打断了
    local isNeedInterrupt = false;

    for k, v in ipairs(self._children) do
        local status = nil;
        if v:getType() == BTreeEnum.Type.Condition then 
            status = v:update();
        elseif v:getType() == BTreeEnum.Type.Decorator then 
            if v:isFinialDecoratorCondition() == true then 
                status = v:drillCheckState(); 
            end 
        end 
        if status ~= nil then 
            if status == BTreeEnum.Status.Failure then 
                return BTreeEnum.Status.Failure;
            else
                isNeedInterrupt = true;
            end 
        end 
    end 

    if isNeedInterrupt == false then 
        return nil;
    else 
        return BTreeEnum.Status.Success;
    end 
end