root = pwd()

using StatsBase, OrderedCollections
using CitableText
using Unicode
datadir = joinpath(root, "data")
phoneticsylls = joinpath(datadir, "syllables-phonetic")
msAfile = joinpath(phoneticsylls, "msAsyllables-phonetic.cex")
hypotacticfile = joinpath(root, "scansion-expanded.cex")


msA = readlines(msAfile)[2:end]
hypotactic = readlines(hypotacticfile)[2:end]


msApsgs = []


for (i, ln) in enumerate(msA)
    cols = split(ln, "|")
    ref = collapsePassageTo(CtsUrn(cols[1]), 2) |>passagecomponent
    push!(msApsgs, ref)
end
msAcounts = countmap(msApsgs)


hypopsgs = []
for (i, ln) in enumerate(hypotactic)
    cols = split(ln, "|")
    ref = CtsUrn(cols[1])|>passagecomponent
    push!(hypopsgs, ref)
end
hypocounts = countmap(hypopsgs)


awol = []
sheep = []
goats = []
for ref in unique(msApsgs)
    if ref in keys(hypocounts)
        if msAcounts[ref] == hypocounts[ref]
            push!(sheep, ref)
        else
            push!(goats, ref)
        end
    else
        push!(awol, ref)
    end
end

@info("good/bad/awol: $(length(sheep)), $(length(goats)), $(length(awol))")



gt = filter(ref -> msAcounts[ref] > hypocounts[ref], goats)
lt = filter(ref -> msAcounts[ref] < hypocounts[ref], goats)


lt[1:100]

function guessmapping_gt(ref, msA, hypotactic)
    @info(ref)
    msAdata = filter(msA) do ln
        cols = split(ln, "|")
        ref == (collapsePassageTo(CtsUrn(cols[1]), 2) |> passagecomponent)
    end
    @info("$(length(msAdata)) syllables in msA")
    hypodata = filter(hypotactic) do ln
        cols = split(ln, "|")
        ref == CtsUrn(cols[1]) |> passagecomponent
    end
    @info("$(length(hypodata)) syllables in hypotactic")

    count = 1
    shortcount = 1
    pairingok = true
    circuitbreaker = 18
    while pairingok && count < circuitbreaker
    # while count < circuitbreaker
        
        msAtext = Unicode.normalize(split(msAdata[count], "|")[2]; stripmark = true) |> lowercase
        hypotextraw = Unicode.normalize(split(hypodata[shortcount], "|")[3]; stripmark = true) |> lowercase
        hypotext = replace(hypotextraw, "’" => "'")
        @info("Compare $(msAtext) with $(hypotext) at count $(count)")
        
        if shortcount == length(hypodata) || count == length(msAdata)
            @warn("Came to end of counting: $(count), $(shortcount)")            
            pairingok = false
       
        elseif msAtext == hypotext
            count = count + 1
            shortcount = shortcount + 1
        else
            @warn("Mismatch $(msAtext) vs $(hypotext)")
            # peek ahead for synizesis:
            if count + 1 <= length(hypodata)
                msAnext =  Unicode.normalize(split(msAdata[count + 1], "|")[2]; stripmark = true) |> lowercase
                combo = msAtext * msAnext
                if combo == hypotext
                    @info("Synizesis or something: $(hypotext)")
                    count = count + 2
                    shortcount = shortcount + 1
                else
                    pairingok = false
                    @warn("Failed on $(combo) vs $(hypotext)")
                end

            else
                @warn("Off the map!")
                pairingok = false
            end
        end

    end
end


x = guessmapping_gt(gt[2], msA, hypotactic)