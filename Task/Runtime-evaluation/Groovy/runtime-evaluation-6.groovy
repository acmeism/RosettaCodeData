def years5 = Eval.xy(2008, 2121, '''
(x..y).findAll {
    Date.parse("yyyy-MM-dd", "${it}-12-25").format("EEE") == "Sun"
}
''')

println years5
