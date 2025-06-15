root = pwd()

using StatsBase, OrderedCollections
using CitableText
using Unicode
using StringDistances

datadir = joinpath(root, "data")
phoneticsylls = joinpath(datadir, "syllables-phonetic")
hypotacticfile = joinpath(root, "scansion-regularized.cex")
hypotactic = readlines(hypotacticfile)[2:end]

function reconstructline(ref, hypodata)
    psgbar = "urn:cts:greekLit:tlg0012.tlg001.hmtx:$(ref)|"
    
    srcdata = filter(l -> startswith(l, psgbar), hypodata)
   # @info("For $psgbar : $(length(srcdata)) lines")
    reconstruction = []
    currword = ""

    for ln in srcdata
        cols = split(ln, "|")
        txt = cols[3]
        wd = cols[5]
        #@info("Look at $(txt) in $(wd)")
        if wd == currword
            push!(reconstruction, txt)
        else
            push!(reconstruction, " $(txt)")
            currword = wd
        end
    end
    join(reconstruction) |> strip
end








src = hmt_cex()
msA = filter(psg -> startswith(workcomponent(psg.urn), "tlg0012.tlg001.msA"),normalizedtexts.passages)


# Try book 1
bk1 = filter(psg -> passagecomponent(collapsePassageTo(urn(psg), 1)) == "1" , msA)



function barebones(s)
    bare = Unicode.normalize(s; stripmark = true)
    replace(bare, r"[ ,;:\.’'`]" => "") 
end

good = 0
bad = 0
reviewthese = []
for psg in bk1
    ref = urn(psg) |> passagecomponent
    msAline = barebones(text(psg))
    hypoline = barebones(reconstructline(ref, hypotactic))
    if msAline  == hypoline
        good = good + 1
        
    else
        bad = bad + 1
        println("Mismatch: $(ref)")
        r = compare(msAline, hypoline, Levenshtein())
        if r < 0.95
            @warn("Distance exceeds limit")
            push!(reviewthese, ref)
        end
        println("Levenshtein distance $(r)")
        println("\t$(msAline)")
        println("\t$(hypoline)")
    end
end

println("Good/Bad: $(good)/$(bad)")

println("Review $(length(reviewthese)) passages")

reviewthese