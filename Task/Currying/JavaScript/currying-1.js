 function addN(n) {
    var curry = function(x) {
        return x + n;
    };
    return curry;
 }

 add2 = addN(2);
 alert(add2);
 alert(add2(7));
