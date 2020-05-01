--[[
    @Author: supercombo519 
    @Date: 2020-03-20 16:47:05 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 16:47:05 
]]
require("behaviortree.nodes.decorator.BaseDecorator")

local super = BaseDecorator
UntilFailure = Cls("UntilFailure", super)

function UntilFailure:update(dt)
    local childStatus = self:getChild():update(dt);
    self:getChild():setStatus(childStatus);

    if childStatus == BTreeEnum.Status.Failure then 
        return BTreeEnum.Status.Failure
    else 
        return BTreeEnum.Status.Running
    end 
end




