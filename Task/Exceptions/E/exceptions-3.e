def nameOf(arg :int, ejector) {
    if (arg == 43) {
        return "Bob"
    } else {
        ejector("Who?")
    }
}

def catching(arg) {
    escape unnamed {
        return ["ok", nameOf(arg, unnamed)]
    } catch exceptionObj {
        return ["notok", exceptionObj]
    }
}
