--[[
    @Author: supercombo519 
    @Date: 2020-04-20 21:02:26 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-04-20 21:02:26 
    血量大于百分比
]]
require("behaviortree.nodes.conditions.BaseCondition")

local super = BaseCondition
HPGreater = Cls("HPGreater", super)

function HPGreater:initialize(value)
    super.initialize(self)
    self._curValue = 80;
    self._greaterThanValue = value
end

function HPGreater:update()
    if self._curValue > self._greaterThanValue then 
        return BTreeEnum.Status.Success
    else 
        return BTreeEnum.Status.Failure;
    end 
end





