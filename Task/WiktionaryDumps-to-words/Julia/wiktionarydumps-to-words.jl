using CodecBzip2

function getwords(io::IO, output::IO; languagemark = "==French==", maxwords = 80)
    title, txopen, txclose = "<title>", "<text", "</text>"
    got_text_last = false
    wordcount, titleword = 0, ""
    for line in eachline(io)
        if occursin(title, line)
            got_text_last = false
            titleword = (m = match(r"<title>([^<]+)</title>", line)) != nothing ? m[1] : ""
        elseif occursin(txopen, line)
            got_text_last = true
        elseif occursin(languagemark, line)
            if got_text_last && titleword != ""
                println(output, titleword)
                (wordcount += 1) >= maxwords && break
            end
            got_text_last = false
        elseif occursin(txclose, line)
            got_text_last = false
        end
    end
end

const url = "https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2"
const urlfile = "wikidump.bz2"
stat(urlfile).size == 0 && download(url, urlfile)
const stream = Bzip2DecompressorStream(open(urlfile))
getwords(stream, stdout)  # or open a file to write to and use its IO handle instead of stdout

