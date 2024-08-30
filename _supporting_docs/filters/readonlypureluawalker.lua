local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or "1")) or 1
end

function pandoc_type(el)
    local result = el.t
    if result == "table" or result == nil then
        return pandoc.utils.type(el)
    end
    return result
end

function lua_readonly_walk(el, filter)
    local t = pandoc_type(el)
    if filter[t] then
        filter[t](el)
    end
    if t == "Blocks" or t == "Inlines" then
        for i = 1, #el do
            lua_readonly_walk(el[i], filter)
        end
    elseif el.content then
        for i = 1, #el.content do
            lua_readonly_walk(el.content[i], filter)
        end
    end
end

function Pandoc(doc)
    local c = 0
    for i = 1, n do
        lua_readonly_walk(doc.blocks, {
            Str = function(el)
                c = c + 1
            end
        })
    end
    -- print(c)
    doc.blocks = pandoc.Blocks({})
    return doc
end

