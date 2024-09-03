local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or pandoc.Blocks({}))) or 1
end

function Pandoc(doc)
    local c = 0
    for i = 1, n do
        doc.blocks = doc.blocks:walk({
            Str = function(s)
                c = c + 1
            end
        })
    end
    return doc
end