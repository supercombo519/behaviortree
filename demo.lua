require("behaviortree.BTree")
require("test.Flee")
require("test.Seek")
require("test.WithinSight")
require("test.HPGreater")
require("test.Attack")


--测试case
local treeCase1 = 
{   
    className = "Selector",
    children = {
        {
            className = "Parallel",
            children = {
                {
                    className = "UntilFailure",
                    children = {
                        {
                            --看见了 falure 没看见 success
                            className = "Inverter",
                            children = {
                                {
                                    className = "WithinSight",
                                }
                            }
                        }
                    },
                },
                {
                    className = "Seek",
                    args = 5, --seek 5s
                },
            },
        },
        {
            className = "Selector",
            children = {
                {
                    className = "Sequence",
                    children = {
                        {
                            className = "HPGreater",
                            args = 50,
                        },
                        {
                            className = "Attack",
                            args = 3, --攻击3s
                        }
                    },
                },
                {
                    className = "Flee",
                }
            },
        }
    },

}

local treeCase2 = 
{   
    className = "Selector",
    children = {
        {
            className = "Sequence",
            selfInterrupt = true,
            lowPriorityInterrupt = true,
            children = {
                {
                    --看见了 falure 没看见 success
                    className = "Inverter",
                    children = {
                        {
                            className = "WithinSight",
                        }
                    }
                },
                {
                    className = "Seek",
                    args = 5, --seek 5s
                },
            },
        },
        {
            className = "Selector",
            children = {
                {
                    className = "Sequence",
                    children = {
                        {
                            className = "HPGreater",
                            args = 50,
                        },
                        {
                            className = "Attack",
                            args = 3, --攻击3s
                        }
                    },
                },
                {
                    className = "Flee",
                }
            },
        }
    },
}

local btree = BTree:new(treeCase2);
btree:update(0.03);
--[[
	每帧执行
	schedule(
	    function(dt)
	        btree:update(dt);
	    end,
	)
]]