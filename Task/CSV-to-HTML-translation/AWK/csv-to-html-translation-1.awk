#!/usr/bin/awk -f
BEGIN {
        FS=","
        print "<table>"
}

{
        gsub(/</, "\\&lt;")
        gsub(/>/, "\\&gt;")
        gsub(/&/, "\\&gt;")
        print "\t<tr>"
        for(f = 1; f <= NF; f++)  {
                if(NR == 1 && header) {
                        printf "\t\t<th>%s</th>\n", $f
                }
                else printf "\t\t<td>%s</td>\n", $f
        }
        print "\t</tr>"
}

END {
        print "</table>"
}
