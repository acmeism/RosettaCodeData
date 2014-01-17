function Difference(A,B)
{
    var a = A.length, b = B.length, c = 0, C = [];
    for (var i = 0; i < a; i++)
     { var j = 0, k = 0;
       while (j < b && B[j] !== A[i]) j++;
       while (k < c && C[k] !== A[i]) k++;
       if (j == b && k == c) C[c++] = A[i];
     }
    return C;
}

function SymmetricDifference(A,B)
{
    var D1 = Difference(A,B), D2 = Difference(B,A),
        a = D1.length, b = D2.length;
    for (var i = 0; i < b; i++) D1[a++] = D2[i];
    return D1;
}


/* Example
   A = ['John', 'Serena', 'Bob', 'Mary', 'Serena'];
   B = ['Jim', 'Mary', 'John', 'Jim', 'Bob'];

   Difference(A,B);           // 'Serena'
   Difference(B,A);           // 'Jim'
   SymmetricDifference(A,B);  // 'Serena','Jim'
*/
