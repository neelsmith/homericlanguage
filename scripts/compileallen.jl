using CitableText
root = pwd()
datafile = joinpath(root, "scansion-expanded.cex")
#Passage|Syllable|SyllableText|MetricLength|Token|Half-line


function sanitize(s)
    quoted = replace(s, "’" => "'")
    replace(quoted, r"'([^ ])" => s"' \1")
end

fulltext = []
hexameter = []
wordref = ""
psgref = ""
sylls = []
for ln in readlines(datafile)[2:end]
    cols = split(ln, "|")
    #@info(cols[3] * "|" * cols[5])
    
    newpsgref = collapsePassageTo(CtsUrn(cols[5]), 2) 
    if psgref != newpsgref
        #@info(">>>New line $(newpsgref)")
        if ! isempty(hexameter)
            push!(hexameter, join(sylls))
           # @info("Add hex $(join(hexameter," "))")
            push!(fulltext,string(psgref, "|", sanitize(join(hexameter, " "))))
        end
        hexameter = []
        sylls = []
        psgref = newpsgref
    end


    newwordref = collapsePassageTo(CtsUrn(cols[5]), 3) |> passagecomponent
    if wordref == newwordref
        #@info("Continue word with $(cols[3])")
        push!(sylls, cols[3])
    else
        #@info("New word ref. $(newwordref) with sylls at $(sylls)")
        if ! isempty(sylls)
            push!(hexameter, join(sylls))
        end
        wordref = newwordref
        sylls = [cols[3]]
    end

  

end

#@info("Add final line $(join(hexameter," "))")
push!(fulltext,string(psgref, "|", join(hexameter, " ")))

fulltext

outfile = joinpath(root, "data", "allen.cex")
open(outfile, "w") do io
    write(io, "#ctsdata\n" * join(fulltext,"\n"))
end