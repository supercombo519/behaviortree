--[[
    @Author: supercombo519 
    @Date: 2020-03-20 14:31:34 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 14:31:34 
]]

BTreeNode = Cls("BTreeNode")

function BTreeNode:initialize()
    self._status = BTreeEnum.Status.Ready;
    --遍历index 
    self._traversalIndex = nil;
    self._tree = nil;
    self._type = nil;
    self._parent = nil;
end

function BTreeNode:reset()
    
end

function BTreeNode:getType()
    return self._type;
end

function BTreeNode:setTree(tree)
    self._tree = tree;
end

function BTreeNode:getTree(tree)
    return tree;
end

function BTreeNode:setParent(parent)
    self._parent = parent;
end

function BTreeNode:getParent()
    return self._parent;
end

function BTreeNode:setTraversalIndex(index)
    self._traversalIndex = index;
end

function BTreeNode:getTraversalIndex( )
    -- assert(self._traversalIndex ~= nil, "error self._traversalIndex = nil")
    return self._traversalIndex;
end

function BTreeNode:getStatus()
    return self._status;
end

function BTreeNode:setStatus(status)
    self._status = status;
end

function BTreeNode:update( )
    
end

--[[
    我是不是child的祖先
]]
function BTreeNode:isAncestor(child)
    local selfTraversalIndex = self._traversalIndex;
    local childTraversalIndex = child:getTraversalIndex();
    if childTraversalIndex < selfTraversalIndex then 
        return false
    end 

    local parent = child:getParent()
    while parent ~= nil do
        if parent == self then 
            return true
        end 
        parent = parent:getParent();
    end
    return false;
end




