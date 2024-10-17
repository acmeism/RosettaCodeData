using FreqTables

txt = read("les-mis.txt", String)
words = split(replace(txt, r"\P{L}"i => " "))
table = sort(freqtable(words); rev=true)
println(table[1:10])
