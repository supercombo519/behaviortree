--[[
    @Author: supercombo519 
    @Date: 2020-03-20 18:25:49 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 18:25:49 
]]
require("behaviortree.nodes.actions.BaseAction")
local super = BaseAction
ShowLog = Cls("ShowLog", super)

function ShowLog:initialize(str)
    super.initialize(self, str)
    self._str = str;
    -- assert(self._str, "error: Log str is nil");
end

function ShowLog:update()
    return BTreeEnum.Status.Success;
end

