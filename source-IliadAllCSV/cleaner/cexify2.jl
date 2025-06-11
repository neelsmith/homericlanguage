using CSV

root = pwd()
filesdir = joinpath(root, "source-IliadAllCSV", "cleaner")
csvlist = filter(f -> endswith(f, "csv"), readdir(filesdir))



formatted = ["URN|Text|Length|Word|Foot|Half-line"]

for bk in 1:24
    data = CSV.File(joinpath(filesdir, csvlist[bk]); drop = [7,8,9,10])    
    @warn("Read these columns:")
    @warn(data.names)
    arr = collect(data)

    currline = 0
    for (i,r) in enumerate(arr)
        urnval = "urn:cts:greekLit:tlg0012.tlg001.hmtx:$(bk).$(r[:Line])"
        delimited = ""
        syllabic = r[3]
        textval = replace(r[2], r"[\.,;·]" => "")
        if i == length(arr)
            syllabic = "anceps"
        elseif r[:Line] != arr[i + 1][:Line]
            syllabic = "anceps"
        end
        wordidx = r[4]
        footidx = r[5]
        halfline = replace(r[6], "hemi" => "")
        delimited = join([urnval, textval, syllabic, wordidx, footidx, halfline], "|")

        
        push!(formatted, delimited)
    end
    
end


open("scansion.cex", "w") do io
    write(io, join(formatted,"\n"))
end