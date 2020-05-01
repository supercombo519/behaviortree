--[[
    @Author: supercombo519 
    @Date: 2020-03-20 15:12:43 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 15:12:43 
]]
require("behaviortree.nodes.actions.BaseAction")
local super = BaseAction
Wait = Cls("Wait", super)

function Wait:initialize(waitTime)
    super.initialize(self, waitTime)
    self._waitTime = waitTime;
    self._leftTime = waitTime;
end

function Wait:reset()
    self._leftTime = self._waitTime;
end

function Wait:update(dt)
    self._leftTime = self._leftTime - dt;
    if self._leftTime <= 0 then 
        self._leftTime = self._waitTime;
        return BTreeEnum.Status.Success;
    else 
        return BTreeEnum.Status.Running;
    end 
end



