--[[
    @Author: supercombo519 
    @Date: 2020-03-20 14:37:33 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 14:37:33 
]]
require("behaviortree.nodes.composites.BaseComposite")
local super = BaseComposite

Selector = Cls("Selector", super)

function Selector:update(dt)
    for k, v in ipairs(self._children) do
        if self:checkIsNeedUpdate(v) then 
            local preStatus = v:getStatus();

            local status = v:update(dt);
            v:setStatus(status);
            if status == BTreeEnum.Status.Success then 
                self:clearRunningChildren();
                return status;
            elseif status == BTreeEnum.Status.Running then 
                self:addRunningChild(v);
                return status;
            end 

            --之前running的结束了，清除runningChildren 好让后续node可以运行
            if preStatus == BTreeEnum.Status.Running and status ~= BTreeEnum.Status.Running then 
                self:clearRunningChildren();
            end 
        end 
    end
    return BTreeEnum.Status.Failure
end

function Selector:checkConditions()
    --若没有条件节点则不需要打断了
    local isNeedInterrupt = false;

    for k, v in ipairs(self._children) do
        local status = nil;
        if v:getType() == BTreeEnum.Type.Condition then 
            status = v:update(0);
        elseif v:getType() == BTreeEnum.Type.Decorator then 
            if v:isFinialDecoratorCondition() == true then 
                status = v:drillCheckState(); 
            end 
        end 
        if status ~= nil then 
            if status == BTreeEnum.Status.Success then 
                return BTreeEnum.Status.Success;
            else
                isNeedInterrupt = true;
            end 
        end 
    end 

    if isNeedInterrupt == false then 
        return nil;
    else 
        return BTreeEnum.Status.Selector;
    end 
end
