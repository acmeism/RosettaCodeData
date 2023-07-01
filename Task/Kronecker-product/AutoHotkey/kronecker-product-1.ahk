KroneckerProduct(a, b){
    prod := [], r:= 1, c := 1
    for i, aa in a
        for j, bb in b
        {
            for k, x in aa
                for l, y in bb
                    prod[R , C++] := x * y
            r++, c:= 1
        }
    return prod
}
