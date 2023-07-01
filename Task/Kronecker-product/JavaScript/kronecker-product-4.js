<!-- KronProdTest2.html -->
<html><head>
  <title>Kronecker product v.2: Sample 1 (from Wikipedia) and Sample 2</title>
  <script src="matkronprod2.js"></script>
  <script>
  var mr,ttl='Kronecker product of A and B matrices';
  [ {a:[[1,2],[3,4]],b:[[0,5],[6,7]] },
    {a:[[0,1,0],[1,1,1],[0,1,0]],b:[[1,1,1,1],[1,0,0,1],[1,1,1,1]] }
  ].forEach(m=>{
    console.log(ttl); pttl2doc(ttl);
    matl2cons('A',m.a); matp2doc('A',m.a);
    matl2cons('B',m.b); matp2doc('B',m.b);
    mr=mkp2(m.a,m.b);
    matl2cons('A x B',mr); matp2doc('A x B',mr);
    })
  </script>
</head><body></body>
</html>
