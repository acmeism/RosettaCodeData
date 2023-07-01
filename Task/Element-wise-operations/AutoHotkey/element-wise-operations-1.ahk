ElementWise(M, operation, Val){
    A := Obj_Copy(M),
    for r, obj in A
        for c, v in obj	{
            V := IsObject(Val) ? Val[r, c] : Val
            switch, operation {
                case "+": A[r, c]	:= A[r, c] + V
                case "-": A[r, c]	:= A[r, c] - V
                case "*": A[r, c]	:= A[r, c] * V
                case "/": A[r, c]	:= A[r, c] / V
                case "Mod": A[r, c]	:= Mod(A[r, c], V)
                case "^": A[r, c]	:= A[r, c] ** V
            }
        }
    return A
}
