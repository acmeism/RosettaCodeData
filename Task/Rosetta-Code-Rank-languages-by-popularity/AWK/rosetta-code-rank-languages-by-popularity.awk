function join(array, start, end, sep,    result, i) {
        result = array[start]
        for (i = start + 1; i <= end; i++)
            result = result sep array[i]
        return result
}

function trim(str) {
        gsub(/^[[:blank:]]+|[[:blank:]\n]+$/, "", str)
        return str
}

function http2var(      site,path,server,j,output) {

        RS = ORS = "\r\n"

        site = "rosettacode.org"
        path = "/mw/api.php" \
            "?action=query" \
            "&generator=categorymembers" \
            "&gcmtitle=Category:Programming%20Languages" \
            "&gcmlimit=500" \
            (gcmcontinue "" ? "&gcmcontinue=" gcmcontinue : "") \
            "&prop=categoryinfo" \
            "&format=txt"

        server = "/inet/tcp/0/" site "/80"
        print "GET " path " HTTP/1.0" |& server
        print "Host: " site |& server
        print "" |& server
        while ((server |& getline) > 0) {
            if($0 != 0) {
                j++
                output[j] = $0
            }
        }
        close(server)
        if(length(output) == 0)
            return -1
        else
            return join(output, 1, j, "\n")
}

function parse(webpage  ,c,a,i,b,e,pages) {

       # Check for API continue code ie. a new page of results available
        match(webpage, "gcmcontinue[]] =>[^)]+[^)]", a)
        if(a[0] != "") {
            split(a[0], b, ">")
            gcmcontinue = trim(b[2])
        } else gcmcontinue = ""

        c = split(webpage, a, "[[][0-9]{1,7}[]]")

        while(i++ < c) {
            if(match(a[i], /[pages]/)) {
                match(a[i], "pages[]] =>[^[]+[^[]", b)
                split(b[0], e, ">")
                pages = trim(e[2]) + 0
            } else pages = 0
            if(match(a[i], /[title]/)) {
                match(a[i], "title[]] =>[^[]+[^[]", b)
                split(b[0], e, ":")
                e[2] = trim(e[2])
                if ( substr(e[2], length(e[2]), 1) == ")" )
                    e[2] = trim( substr(e[2], 1, length(e[2]) - 1) )
                if(length(e[2]) > 0)
                    G[e[2]] = pages
            }
        }
}

BEGIN {

        parse( http2var() )     # First 500
        while ( gcmcontinue != "" )
            parse( http2var() ) # Next 500, etc

        # https://www.gnu.org/software/gawk/manual/html_node/Controlling-Scanning.html
        PROCINFO["sorted_in"] = "@val_type_desc"
        for ( language in G )
            print ++i ". " language " - " G[language]

}
