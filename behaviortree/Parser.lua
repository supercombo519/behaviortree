--[[
    @Author: supercombo519 
    @Date: 2020-03-20 16:54:03 
    @Last Modified by:   supercombo519 
    @Last Modified time: 2020-03-20 16:54:03 
]]

require("behaviortree.nodes.init")

Parser = Cls("Parser")

local __parserInstance = nil 
function Parser:getInstance()
    if __parserInstance==nil then
        __parserInstance = Parser:new()
    end
    return __parserInstance
end

--[[
    {   
        --这个当className
        className = "Sequence",
        args = {},
        children = {
            {
                className = "Log",
                args = "Log1",
            },
            {
                className = "Wait",
                args = 5, --停在这5秒
            },
            {
                className = "Log",
                args = "Log2",
            },
            {
                className = "Selector",
                children = {
                    {
                        className = "Sequence",
                        children = {
                            {
                                className = "WithinSight",
                            },
                            {
                                className = "Seek"
                            },
                        },
                    },
                    {
                        className = "Flee",
                    }
                }
            },
        }
    }
]]
function Parser:run(treeConf, btree)
    self._traversalIndex = 0;
    local ret = self:__parserNode(treeConf, nil, btree);
    return ret;
end

function Parser:__parserNode(nodeConf, parentTree, btree)
    local classProtype = nil;
    if nodeConf.namespace then 
        classProtype = _G[nodeConf.namespace][nodeConf.className];
    else 
        classProtype = _G[nodeConf.className];
    end 

    local node = classProtype:new(nodeConf.args); 
    node:setTraversalIndex(self._traversalIndex);
    node:setTree(btree);
    self._traversalIndex = self._traversalIndex + 1;
    if parentTree then 
        parentTree:addChild(node);
        node:setParent(parentTree);
    end 

    --若是 Composite 或 Decorator 必须有 children
    if node:getType() == BTreeEnum.Type.Composite or node:getType() == BTreeEnum.Type.Decorator then 
        local nodeTypeStr = node:getType() == BTreeEnum.Type.Composite and "Composite" or "Decorator"
        -- assert(nodeConf.children, string.format( "error: %s 节点必须有children", nodeTypeStr));
    end 

    --只有 Composite 才能条件打断
    if node:getType() == BTreeEnum.Type.Composite then 
        if nodeConf.selfInterrupt then 
            btree:addSelfInterruptNode(node);
        end 

        if nodeConf.lowPriorityInterrupt then 
            btree:addLowPriorityInterruptNode(node);
        end 
    end 

    if nodeConf.children then 
        for i, v in ipairs(nodeConf.children) do
            self:__parserNode(v, node, btree);
        end
    end 

    return node;
end


