import static Complex.*

Number.metaClass.mixin ComplexCategory

def π = Math.PI
def e = Math.E

println "e ** (π * i) + 1 = " + (e ** (π * i) + 1)

println "| e ** (π * i) + 1 | = " + (e ** (π * i) + 1).ρ
