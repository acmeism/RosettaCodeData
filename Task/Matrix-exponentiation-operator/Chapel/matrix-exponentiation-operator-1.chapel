proc **(a, e) {
    // create result matrix of same dimensions
    var r:[a.domain] a.eltType;
    // and initialize to identity matrix
    forall ij in r.domain do
        r(ij) = if ij(1) == ij(2) then 1 else 0;

    for 1..e do
        r *= a;

    return r;
}
