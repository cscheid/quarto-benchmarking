local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or "1")) or 1
end

function pandoc_type(el)
    local result = el.tag
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
    local n = 0
    local c = nil
    if t == "Blocks" or t == "Inlines" then
        c = el
        n = #el
    elseif el.content then
        c = el.content
        n = #el.content
    end
    for i = 1, n do
        lua_readonly_walk(c[i], filter)
    end
end

local profiling = false
local profiler = dofile('profiler.lua')
function Pandoc(doc)
    if profiling then
        os.execute('rm -f output.prof')
        profiler.start('output.prof', 1)
    end
    local c = 0
    for i = 1, n do
        if profiling then
            profiler.setcategory('pass-' .. i)
        end
        lua_readonly_walk(doc.blocks, {
            Str = function(el)
                c = c + 1
            end
        })
    end
    print(c)
    doc.blocks = pandoc.Blocks({})
    if profiling then
        profiler.stop()
    end
    return doc
end

