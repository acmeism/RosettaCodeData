def binding = new B inding(startYear: 2008, endYear: 2121)
new GroovyShell( binding ).evaluate('''
yearList = (startYear..endYear).findAll {
    Date.parse("yyyy-MM-dd", "${it}-12-25").format("EEE") == "Sun"
}
''')

println binding.yearList
