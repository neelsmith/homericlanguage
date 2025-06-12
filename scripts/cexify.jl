using CSV

root = pwd()
filesdir = joinpath(root, "source-IliadAllCSV", "cleaner")

csvlist = []
for i in 1:24
    push!(csvlist, joinpath(filesdir, "iliad$(i).csv"))
end

filepaths = map(fname -> joinpath(filesdir, fname), csvlist)



function formatbook(fname, bk; header = false)
    formatted = header ? ["URN|Text|Length|Word|Foot|Half-line"] : []

    data = CSV.File(fname; drop = [7,8,9,10])

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
    formatted
end




alldata = ["URN|Text|Length|Word|Foot|Half-line"]
for book in 1:24
    fname = filepaths[book]
    @info("CHECK DATA FOR BOOK $(book)")
 
    formatted = formatbook(fname, book; header = false)
    sourcedata = readlines(fname)[2:end] # omit header
    if length(formatted) != length(sourcedata)
        @warn("Bad processing for book $(book)")
        @warn("Lengths source/processed: $(length(sourcedata)) / $(length(formatted))")
        @error("Stopping")
    else
        @info("Book $(book) matched")
        push!(alldata, join(formatted,"\n"))
    end
end










open("checkout.cex","w") do io
    write(io, join(alldata,"\n"))
end
#=
for bk in 1:1 #24
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
=#


    #=
open("checkme.cex", "w") do io
    write(io, join(formatted,"\n"))
end
=#