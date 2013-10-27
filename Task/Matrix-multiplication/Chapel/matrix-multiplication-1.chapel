proc *(a:[], b:[]) {

    if (a.eltType != b.eltType) then
        writeln("type mismatch: ", a.eltType, " ", b.eltType);

    var ad = a.domain.dims();
    var bd = b.domain.dims();
    var (arows, acols) = ad;
    var (brows, bcols) = bd;
    if (arows != bcols) then
        writeln("dimension mismatch: ", ad, " ", bd);

    var c:[{arows, bcols}] a.eltType = 0;

    for i in arows do
        for j in bcols do
            for k in acols do
                c(i,j) += a(i,k) * b(k,j);

    return c;
}
