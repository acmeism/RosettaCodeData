isPerfect(n) =>
    n == new List.generate(n-1, (i) => n%(i+1) == 0 ? i+1 : 0).fold(0, (p,n)=>p+n);
