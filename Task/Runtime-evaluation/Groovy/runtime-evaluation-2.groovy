def startYear = 2008
def endYear = 2121
def years2 = new GroovyShell().evaluate("""
(${startYear}..${endYear}).findAll {
    Date.parse("yyyy-MM-dd", "\${it}-12-25").format("EEE") == "Sun"
}
""")

println years2
