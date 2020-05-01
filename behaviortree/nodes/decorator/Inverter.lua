--[[
    @Author: supercombo519 
    @Date: 2020-04-20 20:31:12 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-04-20 20:31:12 
]]

local super = BaseDecorator

Inverter = Cls("Inverter", super)

function Inverter:update(dt)
    local childStatus = self:getChild():update(dt);
    self:getChild():setStatus(childStatus);
    if childStatus == BTreeEnum.Status.Failure then 
        return BTreeEnum.Status.Success;
    elseif childStatus == BTreeEnum.Status.Success then 
        return BTreeEnum.Status.Failure;
    else 
        return BTreeEnum.Status.Running;
    end 
end



