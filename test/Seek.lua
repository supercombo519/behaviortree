--[[
    @Author: guanfeng 
    @Date: 2020-03-20 18:38:41 
    @Last Modified by:   guanfeng 
    @Last Modified time: 2020-03-20 18:38:41 
]]

require("behaviortree.nodes.actions.BaseAction")
local super = BaseAction
Seek = Cls("Seek", super)

function Seek:initialize(time)
    super.initialize(self)
    self._seekTime = time;
    self._leftTime = self._seekTime
end

function Seek:reset()
    self._leftTime = self._seekTime
end

function Seek:update(dt)
    if self._leftTime == self._seekTime then 
        print("Seek begin")
    end 
    self._leftTime = self._leftTime - dt;
    if self._leftTime <= 0 then 
        print("Seek done")
        self._leftTime = self._seekTime;
        return BTreeEnum.Status.Success;
    else 
        return BTreeEnum.Status.Running;
    end 
end

