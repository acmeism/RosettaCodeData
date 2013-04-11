def years1 = new GroovyShell().evaluate('''
(2008..2121).findAll {
    Date.parse("yyyy-MM-dd", "${it}-12-25").format("EEE") == "Sun"
}
''')

println years1
