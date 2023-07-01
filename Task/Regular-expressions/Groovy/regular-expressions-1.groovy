import java.util.regex.*;

def woodchuck = "How much wood would a woodchuck chuck if a woodchuck could chuck wood?"
def pepper = "Peter Piper picked a peck of pickled peppers"


println "=== Regular-expression String syntax (/string/) ==="
def woodRE = /[Ww]o\w+d/
def piperRE = /[Pp]\w+r/
assert woodRE instanceof String && piperRE instanceof String
assert (/[Ww]o\w+d/ == "[Ww]o\\w+d") && (/[Pp]\w+r/ == "[Pp]\\w+r")
println ([woodRE: woodRE, piperRE: piperRE])
println ()


println "=== Pattern (~) operator ==="
def woodPat = ~/[Ww]o\w+d/
def piperPat = ~piperRE
assert woodPat instanceof Pattern && piperPat instanceof Pattern

def woodList = woodchuck.split().grep(woodPat)
println ([exactTokenMatches: woodList])
println ([exactTokenMatches: pepper.split().grep(piperPat)])
println ()


println "=== Matcher (=~) operator ==="
def wwMatcher = (woodchuck =~ woodRE)
def ppMatcher = (pepper =~ /[Pp]\w+r/)
def wpMatcher = (woodchuck =~ /[Pp]\w+r/)
assert wwMatcher instanceof Matcher && ppMatcher instanceof Matcher
assert wwMatcher.toString() == woodPat.matcher(woodchuck).toString()
assert ppMatcher.toString() == piperPat.matcher(pepper).toString()
assert wpMatcher.toString() == piperPat.matcher(woodchuck).toString()

println ([ substringMatches: wwMatcher.collect { it }])
println ([ substringMatches: ppMatcher.collect { it }])
println ([ substringMatches: wpMatcher.collect { it }])
println ()


println "=== Exact Match (==~) operator ==="
def containsWoodRE = /.*/ + woodRE + /.*/
def containsPiperRE = /.*/ + piperRE + /.*/
def wwMatches = (woodchuck ==~ containsWoodRE)
assert wwMatches instanceof Boolean
def wwNotMatches = ! (woodchuck ==~ woodRE)
def ppMatches = (pepper ==~ containsPiperRE)
def pwNotMatches = ! (pepper ==~ containsWoodRE)
def wpNotMatches = ! (woodchuck ==~ containsPiperRE)
assert wwMatches && wwNotMatches && ppMatches && pwNotMatches && pwNotMatches

println ("'${woodchuck}' ${wwNotMatches ? 'does not' : 'does'} match '${woodRE}' exactly")
println ("'${woodchuck}' ${wwMatches ? 'does' : 'does not'} match '${containsWoodRE}' exactly")
