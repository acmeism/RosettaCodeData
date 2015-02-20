def years4 = new GroovyShell( new Binding(startYear: 2008, endYear: 2121) ).evaluate('''
(startYear..endYear).findAll {
    Date.parse("yyyy-MM-dd", "${it}-12-25").format("EEE") == "Sun"
}
''')

println years4
