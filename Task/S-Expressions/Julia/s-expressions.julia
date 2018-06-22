function rewritequotedparen(s)
    segments = split(s, "\"")
    for i in 1:length(segments)
        if i & 1 == 0  # even i
            ret = replace(segments[i], r"\(", s"_O_PAREN")
            segments[i] = replace(ret, r"\)", s"_C_PAREN")
        end
    end
    join(segments, "\"")
end

function reconsdata(n, s)
    if n > 1
        print(" ")
    end
    if s isa String && ismatch(r"[\$\%\!\$\#]", s) == false
        print("\"$s\"")
    else
        print(s)
    end
end

function printAny(anyarr)
    print("(")
    for (i, el) in enumerate(anyarr)
        if el isa Array
            print("(")
            for (j, el2) in enumerate(el)
                if el2 isa Array
                    print("(")
                    for(k, el3) in enumerate(el2)
                        if el3 isa Array
                            print(" (")
                            for(n, el4) in enumerate(el3)
                                reconsdata(n, el4)
                            end
                            print(")")
                        else
                            reconsdata(k, el3)
                        end
                    end
                    print(")")
                else
                    reconsdata(j, el2)
                end
            end
            if i == 1
                print(")\n ")
            else
                print(")")
            end
        end
    end
    println(")")
end

removewhitespace(s) = replace(replace(s, r"\n", " "), r"^\s*(\S.*\S)\s*$", s"\1")
quote3op(s) = replace(s, r"([\$\!\@\#\%]{3})", s"\"\1\"")
paren2bracket(s) = replace(replace(s, r"\(", s"["), r"\)", s"]")
data2symbol(s) = replace(s, "[data", "[:data")
unrewriteparens(s) = replace(replace(s, "_C_PAREN", ")"), "_O_PAREN", "(")
addcommas(s) = replace(replace(s, r"\]\s*\[", "],["), r" (?![a-z])", ",")

inputstring = """
((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))
 """

println("The input string is:\n", inputstring)
processed = (inputstring |> removewhitespace |> rewritequotedparen |> quote3op
                        |> paren2bracket |> data2symbol |> unrewriteparens |> addcommas)
nat = eval(parse("""$processed"""))
println("The processed native structure is:\n", nat)
println("The reconstructed string is:\n"), printAny(nat)
