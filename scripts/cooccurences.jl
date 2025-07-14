using VectorAlignments
using StatsBase

f = joinpath(pwd(), "data", "allen.cex")
lns = readlines(f)[2:end]

clusters = slidingwindow(lns, n = 2)

allpairs = []
for cluster in clusters#[1:2]
    clusterwords = []
    for hexameter in cluster
        cols = split(hexameter, "|")
        push!(clusterwords, split(cols[2]))
    end
    wordlist = vcat(clusterwords...)
    #@info(wordlist)
    for wrd in wordlist
        for linkedword in wordlist
            if wrd != linkedword
                push!(allpairs, (wrd, linkedword))
            end
        end
    end
end

@info(string("Pairs: ", length(allpairs)))

uniquewords = map(pr -> pr[1], allpairs) |> unique
@info(string("Words: ", length(uniquewords)))

doubledict = Dict()
for (i,wrd) in enumerate(uniquewords)
    if i % 200 == 0
        @info("$(i)/$(length(uniquewords))...")
    end
    cooccurs = filter(pr -> pr[1] == wrd, allpairs)
    cooccurcounts = map(pr -> pr[2], cooccurs) |> countmap
    #@info(wrd," => ", cooccurcounts)
    doubledict[wrd] = cooccurcounts
end

@info(doubledict["ἔθηκε"])


delimited = []
for k in keys(doubledict)
    kdict = doubledict[k]
    for k2 in keys(kdict)
        triple = join([k, k2, kdict[k2]], "|")
        push!(delimited,triple)
    end
end

open("coocurcounts.cex", "w") do io
    write(io, join(delimited, "\n"))
end