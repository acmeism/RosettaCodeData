def nameOf(arg :int) {
    if (arg == 43) {
        return "Bob"
    } else {
        throw("Who?")
    }
}

def catching(arg) {
    try {
        return ["ok", nameOf(arg)]
    } catch exceptionObj {
        return ["notok", exceptionObj]
    }
}
