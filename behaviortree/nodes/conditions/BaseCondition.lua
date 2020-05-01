--[[
    @Author: supercombo519 
    @Date: 2020-03-20 15:20:00 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 15:20:00 
]]
require("behaviortree.nodes.BTreeNode")

local super = BTreeNode
BaseCondition = Cls("BaseCondition", super)

function BaseCondition:initialize()
    super.initialize(self)
    --是否能打断低优先级
    self._type = BTreeEnum.Type.Condition;
end




