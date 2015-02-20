def context = new Binding()
context.startYear = 2008
context.endYear = 2121
def years3 = new GroovyShell(context).evaluate('''
(startYear..endYear).findAll {
    Date.parse("yyyy-MM-dd", "${it}-12-25").format("EEE") == "Sun"
}
''')
