local jog = dofile('../src/jog/jog.lua')
local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or pandoc.Blocks({}))) or 1
end

function Pandoc(doc)
    local c = 0
    for i = 1, n do
        doc.blocks = jog(doc.blocks, {
            Str = function(s)
                c = c + 1
            end
        })
    end
    return doc
end