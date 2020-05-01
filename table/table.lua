local table = table

function table.length(t)
    local count = 0;
    for k,v in pairs(t) do
        count = count + 1;
    end
    return count;
end


function table.clear(t)
    for i = #t, 1, -1 do
        table_remove(t, i)
    end

    for k, v in pairs(t) do
        t[k] = nil
    end

    return t
end

