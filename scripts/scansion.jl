using HmtArchive, HmtArchive.Analysis
using PolytonicGreek, Orthography
using CitableText, CitableCorpus


src = hmt_cex()
hmt_releaseinfo(src)

normalizedtexts = hmt_normalized(src)

iliads = filter(psg -> startswith(workcomponent(psg.urn), "tlg0012.tlg001"),normalizedtexts.passages)
versions = map(psg -> versionid(psg.urn), iliads) |> unique
hmtiliads = map(versions) do vers
    filter(p -> versionid(p.urn) == vers, iliads)
end

# Metadata: let's figure out what books appear in each HMT Iliad:
for hmtiliad in hmtiliads
    iliadversion = map(p -> versionid(p.urn), hmtiliad) |> unique
    
    books = map(p -> passageparts(p.urn)[1], hmtiliad) |> unique
    booklist = join(books, ", ")
    @info("$(iliadversion): $(length(books)) books")
    @info("$(iliadversion): $(booklist)")
end


# 
lg = literaryGreek()


function citablesyllables(psg::CitablePassage; ortho = literaryGreek())
    lextokens = filter(t -> tokencategory(t) isa LexicalToken, tokenize(psg, ortho))

    sylldata = String[]
    for tkn in lextokens
        sylls = syllabify(lowercase(tokentext(tkn)), lg) 
        for (i, syll) in enumerate(sylls)
            syllid = "$(passagecomponent(urn(tkn))).$(i)"
            push!(sylldata, "$(syllid)|$(syll)")
        end
    end
    sylldata
end



for hmtiliad in hmtiliads
    iliadversion = map(p -> versionid(p.urn), hmtiliad) |> unique |> String

    @info("Start processing $(iliadversion)")
    iliadsyllables = ["urn|text"]    
    for (i,p) in enumerate(hmtiliad)
        iliadsyllables = vcat(iliadsyllables, citablesyllables(p))
        if mod(i, 500) == 0
            @info(urn(p))
        end
    end

    open("$(iliadversion)syllables-phonetic.cex", "w") do io
        write(io, join(iliadsyllables, "\n"))
    end
end






