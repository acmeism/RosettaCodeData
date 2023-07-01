import Utils		# To get the FindFirst class

procedure main()
    keys := ["{{header|","<lang>"]
    lang := "No language"
    tags := table(0)
    total := 0

    ff := FindFirst(keys)
    f := reads(&input, -1)

    f ? while tab(ff.locate()) do {
        if "{{header|" == 1(ff.getMatch(), ff.moveMatch()) then lang := map(tab(upto("}}")))
        else (tags[lang] +:= 1, total +:= 1)
        }

    write(total," bare language tags:\n")
    every pair := !sort(tags) do write(pair[2]," in ",pair[1])
end
