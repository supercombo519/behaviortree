--[[
    @Author: supercombo519 
    @Date: 2020-03-20 18:49:25 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 18:49:25 
]]
require("behaviortree.nodes.actions.BaseAction")

local super = BaseAction
Flee = Cls("Flee", super)

function Flee:update()
    print("Flee")
    return BTreeEnum.Status.Success;
end




