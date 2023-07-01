import Exceptions

class U0 : Exception()
    method getMessage()
        return "U0: " || (\message | "unknown")
    end
end

class U1 : Exception()
    method getMessage()
        return "U1: " || (\message | "unknown")
    end
end

procedure main()
    # (Because Exceptions are not built into Unicon, uncaught
    #   exceptions are ignored.  This clause will catch any
    #   exceptions not caught farther down in the code.)
    case Try().call{ foo() } of {
        Try().catch(): {
            ex := Try().getException()
            write(ex.getMessage(), ":\n", ex.getLocation())
            }
        }
end

procedure foo()
    every 1|2 do {
        case Try().call{ bar() } of {
            Try().catch("U0"): {
                ex := Try().getException()
                write(ex.getMessage(), ":\n", ex.getLocation())
                }
            }
        }
end

procedure bar()
    return baz()
end

procedure baz()
    initial U0().throw("First exception")
    U1().throw("Second exception")
end
