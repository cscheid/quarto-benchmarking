local n

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times)) or 1
end

function Pandoc(doc)
    for i = 1, n do
        doc.blocks = doc.blocks:walk({})
    end
    return doc
end