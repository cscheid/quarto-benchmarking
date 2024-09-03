
local json = dofile("../src/json.lua")

function tdump(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

function to_lua(doc)
    local tbl
    local dispatch
    tbl = {
        Str = function(str)
            return {
                t = "Str",
                c = str.text
            }
        end,
        Space = function(space)
            return {
                t = "Space"
            }
        end,
        Para = function(para)
            return {
                t = "Para",
                c = tbl.Inlines(para.content)
            }
        end,
        SoftBreak = function(sb)
            return {
                t = "SoftBreak"
            }
        end,
        Inlines = function(inlines)
            local res = {}
            for i, inline in pairs(inlines) do
                res[i] = dispatch(inline)
            end
            return res
        end,
        Blocks = function(blocks)
            local res = {}
            for i, block in ipairs(blocks) do
                res[i] = dispatch(block)
            end
            return res
        end,
        Meta = function(meta)
            local res = {}
            for k, v in pairs(meta) do
                res[k] = dispatch(v)
            end
            return res
        end,
        Pandoc = function(doc)
            return {
                t = "Pandoc",
                meta = tbl.Meta(doc.meta),
                blocks = tbl.Blocks(doc.blocks)
            }
        end
    }
    dispatch = function(element)
        local tp = element.t or pandoc.utils.type(element)
        if tbl[tp] == nil then
            print("No tbl entry for " .. tp)
        end
        return tbl[tp](element)
    end
    
    return tbl.Pandoc(doc)
end

local walkers
walkers = {
    Meta = function(meta, filter)
        if filter.Meta then
            filter.Meta(meta)
        end
    end,
    Para = function(para, filter)
        if filter.Para then
            filter.Para(para)
        end
        if para.c then
            walkers.Inlines(para.c, filter)
        end
    end,
    Inlines = function(inlines, filter)
        for i, inline in ipairs(inlines) do
            local t = inline.t
            if walkers[t] == nil then
                print("No walker for " .. t)
                crash()
            end
            walkers[t](inline, filter)
        end
    end,
    Str = function(str, filter)
        if filter.Str then
            filter.Str(str)
        end
    end,
    Space = function(space, filter)
        if filter.Space then
            filter.Space(space)
        end
    end,
    SoftBreak = function(sb, filter)
        if filter.SoftBreak then
            filter.SoftBreak(sb)
        end
    end,
    Blocks = function(blocks, filter)
        for i, block in ipairs(blocks) do
            local t = block.t
            if walkers[t] == nil then
                print("No walker for " .. t)
                crash()
            end
            walkers[t](block, filter)
        end
    end,
    Pandoc = function(doc, filter)
        walkers.Meta(doc.meta, filter)
        walkers.Blocks(doc.blocks, filter)
    end,
}

function Pandoc(doc)
    local n_times = 10
    local c = 0
    local data = to_lua(doc)
    -- local data = json.decode(pandoc.write(doc, 'json'))
    -- -- -- tdump(data.blocks)
    for i = 1, n_times do
        walkers.Pandoc(data, {
            Str = function(s)
                c = c + 1
            end
        })
    end
    print(c)
end