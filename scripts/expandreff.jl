f = "scansion.cex"
data = readlines(f)[2:end]

global currfoot = 0
currsyll = 0
currtoken = 0
syllnum = 0


delimitedoutput = ["Passage|Syllable|SyllableText|MetricLength|Token|Half-line"]
for ln in data
    syllurn = ""
    cols = split(ln, "|")
    psgurn = cols[1]
    sylltext = cols[2]
    sylllength = cols[3]
    tknidx = cols[4]
    halfline = cols[6]
    

    tokennum = cols[4]
    if tokennum != currtoken
        currtoken = tokennum
    end

    tokenurn = psgurn * "." * tokennum
    footnum = cols[5]
    if footnum != currfoot
        
        global currfoot = footnum
        
        syllnum = 1
        #@info("Chnage foot to $(currfoot), syllnum to 1")
        syllurn = join([psgurn,currfoot,syllnum],".")
    else 

        syllnum =  syllnum + 1
        syllurn = join([psgurn,currfoot,syllnum],".")
        #@warn("New syllurn " * syllurn)
    end
    #@warn(syllurn * ": " * sylltext * ", " * syllval)
    delimitedline = join([psgurn,syllurn,sylltext,sylllength,tokenurn,halfline], "|")
    push!(delimitedoutput, delimitedline)
end

open("scansion-expanded.cex","w") do io
    write(io, join(delimitedoutput, "\n"))
end

# Passage|SyllableText|MetricLength|Token|Foot|Half-line