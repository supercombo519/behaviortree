--[[
    @Author: supercombo519 
    @Date: 2020-03-20 16:24:44 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 16:24:44 

    修饰节点的base
]]

require("behaviortree.nodes.BTreeNode")

local super = BTreeNode
BaseDecorator = Cls("BaseDecorator", super)

function BaseDecorator:initialize()
    super.initialize(self)
    --是否能打断低优先级
    self._type = BTreeEnum.Type.Decorator;
    --这是被装饰的对象
    self._child = nil;
end

function BaseDecorator:addChild(child)
    self._child = child;
end

function BaseDecorator:getChild()
    return self._child;
end

--最后修饰的是condition
function BaseDecorator:isFinialDecoratorCondition()
    --找到最后的修饰节点
    local child = self._child;
    while child.getChild ~= nil and child:getChild() ~= nil do
        child = child:getChild();
    end
    local childType = child:getType();
    if childType == BTreeEnum.Type.Condition then  
        return true;
    else 
        return false;
    end 
end

--[[
    只有最后是condition才用这个 预先得到 返回状态
]]
function BaseDecorator:drillCheckState()
    local ret = nil;
    if self:isFinialDecoratorCondition() then 
        ret = self:update(0);
    end 
    return ret;
end

