using VectorAlignments

f = joinpath(pwd(), "data", "allen.cex")
lns = readlines(f)[2:end]

clusters = slidingwindow(lns, n = 3)

for cluster in clusters[1:2]
    clusterwords = []
    for hexameter in cluster
        cols = split(hexameter, "|")
        push!(clusterwords, split(cols[2]))
    end
    wordlist = vcat(clusterwords...)
    @info(wordlist)
end
