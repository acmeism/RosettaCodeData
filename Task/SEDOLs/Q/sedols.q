scd:{
    v:{("i"$x) - ?[("0"<=x) & x<="9"; "i"$"0"; -10+"i"$"A"]} each x; / Turn characters of SEDOL into their values
    w:sum v*1 3 1 7 3 9;        / Weighted sum of values
    d:(10 - w mod 10) mod 10;   / Check digit value
    x,"c"$(("i"$"0")+d)         / Append to SEDOL
}

scd each ("710889";"B0YBKJ";"406566";"B0YBLH";"228276";"B0YBKL";"557910";"B0YBKR";"585284";"B0YBKT";"B00030")
