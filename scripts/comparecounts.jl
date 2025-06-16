root = pwd()

using HmtArchive, HmtArchive.Analysis
using CitableText, CitableCorpus, CitableBase
using Unicode
using StringDistances
using StatsBase

datadir = joinpath(root, "data")
phoneticsylls = joinpath(datadir, "syllables-phonetic")
msAfile = joinpath(phoneticsylls, "msAsyllables-phonetic.cex")
hypotacticfile = joinpath(root, "scansion-regularized.cex")

msA = readlines(msAfile)[2:end]
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
    circuitbreaker = 23 # all dactyls = 17 phonetic syllables;  will never approach all dactyls with 6 instances of synizesis from 23 syllables
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


function guessmapping_lt(ref, msA, hypotactic)
    @info(ref)
    msAdata = filter(msA) do ln
        cols = split(ln, "|")
        ref == (collapsePassageTo(CtsUrn(cols[1]), 2) |> passagecomponent)
    end
    #map(msData)
    @info("$(length(msAdata)) syllables in msA")
    hypodata = filter(hypotactic) do ln
        cols = split(ln, "|")
        ref == CtsUrn(cols[1]) |> passagecomponent
    end
    @info("$(length(hypodata)) syllables in hypotactic")    
  
 
    count = 1
    longcount = 1
    pairingok = true
    circuitbreaker = 23 # all dactyls = 17 phonetic syllables;  will never approach all dactyls with 6 instances of synizesis from 23 syllables
    while pairingok && count < circuitbreaker     
        msAtext = Unicode.normalize(split(msAdata[longcount], "|")[2]; stripmark = true) |> lowercase
        hypotextraw = Unicode.normalize(split(hypodata[count], "|")[3]; stripmark = true) |> lowercase
        hypotext = replace(hypotextraw, "’" => "'")
        @info("Compare $(msAtext) with $(hypotext) at count $(count)")

        if longcount == length(msAdata) || count == length(hypodata)
            @warn("Came to end of counting: $(count), $(longcount)")            
            pairingok = false
        
        elseif msAtext == hypotext
            count = count + 1
            longcount = longcount + 1
        else
             @warn("Mismatch $(msAtext) vs $(hypotext)")
            # peek ahead for synizesis:
            if count + 1 <= length(msAdata)
                msAnext =  Unicode.normalize(split(msAdata[count + 1], "|")[2]; stripmark = true) |> lowercase
                combo = msAtext * msAnext
                if combo == hypotext
                    @info("Synizesis or something: $(hypotext)")
                    count = count + 2
                    longcount = longcount + 1
                else
                    pairingok = false
                    @warn("Failed on $(combo) vs $(hypotext)")
                end

            else
                @warn("Off the map!")
                pairingok = false
            end
        end

       # count = count + 1
       # longcount = longcount + 1
    end
end


hmtsrc = hmt_cex()
normied = hmt_normalized(hmtsrc)
vapsgs = filter(psg -> "tlg0012.tlg001.msA.normalized" == workcomponent(urn(psg)), normied.passages)
testref = lt[3]

function test_lt(ref, msA, hypotactic, vapsgs)
    msApsg = "urn:cts:greekLit:tlg0012.tlg001.msA.normalized:$(ref)"
    vapsg = filter(p -> string(urn(p)) == msApsg, vapsgs)
    println(vapsg[1].text)
    println(reconstructline(ref, hypotactic))
    guessmapping_lt(ref, msA, hypotactic)
end


test_lt(testref, msA, hypotactic, vapsgs)

