function GCD(A)   // A is an integer array (e.g. [57,0,-45,-18,90,447])
{
    var n = A.length, x = A[0] < 0 ? -A[0] : A[0];
    for (var i = 1; i < n; i++)
     { var y = A[i] < 0 ? -A[i] : A[i];
       while (x && y){ x > y ? x %= y : y %= x; }
       x += y;
     }
    return x;
}

/* For example:
   GCD([57,0,-45,-18,90,447]) -> 3
*/
