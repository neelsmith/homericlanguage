root = pwd()
csvlist = filter(f -> endswith(f, "csv"), readdir(root))


formatted = ["URN|Text|Length|Word|Foot|Half-line"]
for i in 1:24
    println(i)
    lines = readlines(csvlist[i])[2:end]
    
    for ln in lines
        cols = split(ln, ",")
        #println(cols)
        urnval = "urn:cts:greekLit:tlg0012.tlg001.hmtx:$(i).$(cols[1])"
        if length(cols) < 6
            @warn("Invalid dataline in file $(csvlist[i]): $(ln)")
        end
        #println(urnval)
        txtval = replace(cols[2], '"' => "")
        syllabicval = cols[3]
        wordidx = cols[4]
        footidx = cols[5]
        halfline = cols[6]
        outline = join([urnval, txtval, syllabicval, wordidx, footidx, halfline], "|")
        push!(formatted, outline)
    end
end

open("formatted.cex", "w") do io
    write(io, join(formatted,"\n"))
end