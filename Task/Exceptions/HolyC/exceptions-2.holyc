import Exceptions

procedure main(A)
    every i := !A do {
        case Try().call{ write(g(i)) } of {
            Try().catch(): {
                x := Try().getException()
                write(x.getMessage(), ":\n", x.getLocation())
                }
            }
        }
end

procedure g(i)
    if numeric(i) = 3 then Exception().throw("bad value of "||i)
    return i
end
