function csv_tsv(str)
    p = split(str, ",")
    for (i, f) in enumerate(p)
        if count(==('"'), f) > 1
            p[i] = replace(strip(f, [' ', '"']), "\"\"" => "\"")
        elseif f == "\""
            p[i] = ""
        end
    end
    t = join(p,"<TAB>")
    s = replace(str, "\\" => "\\\\", "\t" => "\\t", "\0" => "\\0", "\n" => "\\n", "\r" => "\\r")
    t = replace(t, "\\" => "\\\\", "\t" => "\\t", "\0" => "\\0", "\n" => "\\n", "\r" => "\\r")
    return s, t
end

const testfile = "test.tmp"
fh = open(testfile, "w")

write(fh, """
a,"b"
"a","b""c"

,a
a,"
 a , "b"
"12",34
a\tb, TAB
a\\tb
a\\n\\rb
a\0b, NUL
a\rb, RETURN
a\\b""")

close(fh)

for test_string in split(read(testfile, String), "\n")
    csv, tsv = csv_tsv(test_string)
    println(lpad(csv, 12), " => ", tsv)
end
