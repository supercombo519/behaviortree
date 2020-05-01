--[[
    @Author: supercombo519 
    @Date: 2020-03-20 18:20:28 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 18:20:28 
]]

require("behaviortree.nodes.conditions.BaseCondition")

local super = BaseCondition
WithinSight = Cls("WithinSight", super)

--test
g_testWithinSight = true

function WithinSight:update()
    if g_testWithinSight then 
        return BTreeEnum.Status.Success;
    else 
        return BTreeEnum.Status.Failure;
    end 
end



