procedure main(A)
    add2 := addN(2)
    write("add2(7) = ",add2(7))
    write("add2(1) = ",add2(1))
end

procedure addN(n)
    return makeProc{ repeat { (x := (x@&source)[1], x +:= n) } }
end

procedure makeProc(A)
    return (@A[1], A[1])
end
