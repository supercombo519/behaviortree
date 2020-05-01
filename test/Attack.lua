--[[
    @Author: guanfeng 
    @Date: 2020-04-20 21:33:50 
    @Last Modified by:   guanfeng 
    @Last Modified time: 2020-04-20 21:33:50 
]]
require("behaviortree.nodes.actions.BaseAction")
local super = BaseAction
Attack = Cls("Attack", super)

function Attack:initialize(time)
    super.initialize(self)
    self._attackTime = time;
    self._leftTime = self._attackTime
end

function Attack:reset()
    self._leftTime = self._attackTime
end

function Attack:update(dt)
    if self._leftTime == self._attackTime then 
        print("Attack begin")
    end 

    self._leftTime = self._leftTime - dt;
    if self._leftTime <= 0 then 
        print("Attack done")
        self._leftTime = self._attackTime;
        return BTreeEnum.Status.Success;
    else 
        return BTreeEnum.Status.Running;
    end 
end