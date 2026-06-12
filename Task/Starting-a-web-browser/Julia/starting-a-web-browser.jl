using Tables, BrowseTables

function testbrowsertable(addresstext)
    lines = strip.(split(addresstext, "\n"))
    mat = fill("", length(lines), 2)
    regex = r"""^ (.*?) \s+
                  (
                      \d* (\-|\/)? \d*
                    | \d{1,3} [a-zI./ ]* \d{0,3}
                  )
            $"""x
    for (i, line) in enumerate(lines)
        if (matched = match(regex, line)) != nothing
            mat[i, 1], mat[i, 2] = matched.captures
        end
    end
    data = Tables.table(mat)
    tmp = tempname() * ".html"
    write_html_table(tmp, data)
    if Sys.isapple()
        run(`open $tmp`)
    elseif Sys.iswindows()
        run(`cmd /c start $tmp`)
    else # linux etc.
        run(`xdg-open $tmp`)
    end
    println("Press Enter after you close the browser to exit and remove temp file.")
    readline()
    rm(tmp)
end

const adressen = """
    Plataanstraat 5
    Straat 12
    Straat 12 II
    Dr. J. Straat   12
    Dr. J. Straat 12 a
    Dr. J. Straat 12-14
    Laan 1940 – 1945 37
    Plein 1940 2
    1213-laan 11
    16 april 1944 Pad 1
    1e Kruisweg 36
    Laan 1940-’45 66
    Laan ’40-’45
    Langeloërduinen 3 46
    Marienwaerdt 2e Dreef 2
    Provincialeweg N205 1
    Rivium 2e Straat 59.
    Nieuwe gracht 20rd
    Nieuwe gracht 20rd 2
    Nieuwe gracht 20zw /2
    Nieuwe gracht 20zw/3
    Nieuwe gracht 20 zw/4
    Bahnhofstr. 4
    Wertstr. 10
    Lindenhof 1
    Nordesch 20
    Weilstr. 6
    Harthauer Weg 2
    Mainaustr. 49
    August-Horch-Str. 3
    Marktplatz 31
    Schmidener Weg 3
    Karl-Weysser-Str. 6"""

testbrowsertable(adressen)
