local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or "1")) or 1
end

function Pandoc(doc)
    local c = 0
    for i = 1, n do
        doc.blocks = doc.blocks:walk({
            Str = function(el)
                c = c + 1
            end
        })
    end
    -- print(c)
    doc.blocks = pandoc.Blocks({})
    return doc
end