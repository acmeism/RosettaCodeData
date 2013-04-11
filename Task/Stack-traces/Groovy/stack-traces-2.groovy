def trace = rawTrace().collect {
    def props = it.properties
    def keys = (it.properties.keySet() - (new Object().properties.keySet()))
    props.findAll{ k, v -> k in keys }
}

def propNames = trace[0].keySet().sort()
def propWidths = propNames.collect { name -> [name, trace.collect{ it[name].toString() }].flatten()*.size().max() }

propNames.eachWithIndex{ name, i -> printf("%-${propWidths[i]}s  ", name) }; println ''
propWidths.each{ width -> print('-' * width + '  ') }; println ''
trace.each {
    propNames.eachWithIndex{ name, i -> printf("%-${propWidths[i]}s  ", it[name].toString()) }; println ''
}
