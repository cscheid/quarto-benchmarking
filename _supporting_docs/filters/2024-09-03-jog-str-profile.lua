local jog = dofile('../src/jog/jog.lua')
local n
local profile_name = "2024-09-03-jog.profile"

function Meta(meta)
    n = tonumber(pandoc.utils.stringify(meta.n_times or pandoc.Blocks({}))) or 1
    profile_name = pandoc.utils.stringify(meta.profile_name or pandoc.Blocks({ pandoc.Str(profile_name)}))
end

local profiler = dofile('../src/profiler.lua')
function Pandoc(doc)
    profiler.start(profile_name, 5, "w")
    local c = 0
    for i = 1, n do
        doc.blocks = jog(doc.blocks, {
            Str = function(s)
                c = c + 1
            end
        })
    end
    profiler.stop()
    return doc
end