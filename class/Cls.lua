--[[
    @Author: supercombo519 
    @Date: 2020-04-07 21:49:59 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-04-07 21:49:59 
]]
local baseSuper = {initialize = function () end}
baseSuper.__index = baseSuper

Cls = function (className, SuperClass)
    local cls = {__className = className};

    local super = SuperClass or baseSuper
    
    cls.super = SuperClass or baseSuper;
    
    setmetatable(cls, super);

    cls.__index = cls;

    function cls:new(...)
        local obj = {};
        setmetatable(obj, cls);
        obj:initialize(...)
        return obj;
    end

    return cls;
end

