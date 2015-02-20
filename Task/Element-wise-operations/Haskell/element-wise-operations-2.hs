procedure main()
   a := [[1,2,3],[4,5,6],[7,8,9]]
   b := [[9,8,7],[6,5,4],[3,2,1]]
   showMat("  a: ",a)
   showMat("  b: ",b)
   showMat("a+b: ",mmop("+",a,b))
   showMat("a-b: ",mmop("-",a,b))
   showMat("a*b: ",mmop("*",a,b))
   showMat("a/b: ",mmop("/",a,b))
   showMat("a^b: ",mmop("^",a,b))
   showMat("a+2: ",msop("+",a,2))
   showMat("a-2: ",msop("-",a,2))
   showMat("a*2: ",msop("*",a,2))
   showMat("a/2: ",msop("/",a,2))
   showMat("a^2: ",msop("^",a,2))
end

procedure mmop(op,A,B)
    if (*A = *B) & (*A[1] = *B[1]) then {
        C := [: |list(*A[1])\*A[1] :]
        a1 := create !!A
        b1 := create !!B
        every (!!C) := op(@a1,@b1)
        return C
        }
end

procedure msop(op,A,s)
    C := [: |list(*A[1])\*A[1] :]
    a1 := create !!A
    every (!!C) := op(@a1,s)
    return C
end

procedure showMat(label, m)
    every writes(label | right(!!m,5) | "\n")
end
