--[[
    @Author: supercombo519 
    @Date: 2020-03-20 17:57:44 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 17:57:44 
]]
require("behaviortree.nodes.BTreeNode")

local super = BTreeNode
BaseAction = Cls("BaseAction", super)

function BaseAction:initialize()
    super.initialize(self);
    self._type = BTreeEnum.Type.Action;
end

--判断前置条件 
function BaseAction:update()
    
end


