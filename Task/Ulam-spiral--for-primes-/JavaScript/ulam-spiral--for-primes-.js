<!-- UlamSpiral.html -->
<html>
<head><title>Ulam Spiral</title>
    <script src="VOE.js"></script>
<script>
// http://rosettacode.org/wiki/User:AnatolV/Helper_Functions
// Use v.2.0
var pst;

// ***** Additional helper functions
// Pad number from left
function padLeft(n,ns) {
  return ("     " + n).slice(-ns);
}

// Is number n a prime?
function isPrime(n) {
  var n2=Math.sqrt(n);
  for(var i=2; i<=n2; i++) {
    if(n%i === 0) return false;
  }//fend i
  return n !== 1;
}

function insm(mat,x,y) {
  var xz=mat[0].length, yz=xz;
  return(x>=0 && x<xz && y>=0 && y<yz)
}
// *****

function rbCheck() {
  if (document.getElementById('rbDef').checked) {pst=0}
  if (document.getElementById('rbAst').checked) {pst=1}
  if (document.getElementById('rbNum').checked) {pst=2}
}
function rbSet() {
  document.getElementById("rbDef").checked = true;
  rbCheck();
}

// The Ulam Spiral
function pspUlam() {
  var i, j, x, y, xmx, ymx, cnt, dir, M, Mij, sp=" ", sc=3;
  // Setting basic vars for canvas and matrix
  var cvs = document.getElementById('cvsId');
  var ctx = cvs.getContext("2d");
  if(pst<0||pst>2) {pst=0}
  if(pst==0) {n=100; sc=3} else {n=10; sc=5}
  console.log("sc", typeof(sc));
  if(n%2==0) {n++};
  var n2=n*n, pch, sz=n2.toString().length, pch2=sp.repeat(sz);
  var fgc="navy", bgc="white";
  // Create matrix, finding number of rows and columns
  var M=new Array(n);
  for (i=0; i<n; i++) { M[i]=new Array(n);
    for (j=0; j<n; j++) {M[i][j]=0} }
  var r = M[0].length, c = M.length, k=0, dsz=1;
  // Logging init parameters
  var ttl="Matrix ("+r+","+c+")";
  console.log(" *** Ulam spiral: ",n,"x",n,"p-flag=",pst, "sc", sc);
  // Generating and plotting Ulam spiral
  x=y=Math.floor(n/2)+1; xmx=ymx=cnt=1; dir="R";
  for(var i=1; i<=n2; i++) {  //
    if(isPrime(i))  // if prime
      { if(!insm(M,x,y)) {break};
        if(pst==2) {M[y][x]=i} else {M[y][x]=1};
      }
    // all numbers
    if(dir=="R") {if(xmx>0){x++;xmx--} else {dir="U";ymx=cnt;y--;ymx--} continue};
    if(dir=="U") {if(ymx>0){y--;ymx--} else {dir="L";cnt++;xmx=cnt;x--;xmx--} continue};
    if(dir=="L") {if(xmx>0){x--;xmx--} else {dir="D";ymx=cnt;y++;ymx--} continue};
    if(dir=="D") {if(ymx>0){y++;ymx--} else {dir="R";cnt++;xmx=cnt;x++;xmx--}; continue};
  }//fend i
  //Plot/Print according to the p-flag(0-real plot,1-"*",2-primes)
  if(pst==0) {pmat01(M, fgc, bgc, sc, 0); return};
  var logs;
  if(pst==1) {for(i=1;i<n;i++) {logs="|";
                 for(j=1;j<n;j++) { Mij=M[i][j]; if(Mij>0) {pch="*"} else {pch=" "};
                   logs+=" "+pch;}
               logs+="|"; console.log(logs);}//fiend
              pmat01(M, fgc, bgc, sc, 0); console.log("sc", sc);
              return;
              }//ifend
                   //console.log(" ",pch);} console.log(" ")}; return};
  if(pst==2) {for(i=1;i<n;i++) {logs="|";
                 for(j=1;j<n;j++) {Mij=M[i][j];
                   if(Mij==0) {pch=pch2}
                   else {pch=padLeft(Mij,sz)};
                   logs+=pch; }  //" "+
               logs+=" |"; console.log(logs);}//fiend
              pmat01(M, fgc, bgc, sc, 0); console.log("sc", sc);
			  return;
			  }//ifend

}//func end
// ******************************************
</script></head>
<body onload='rbSet();' style="font-family: arial, helvatica, sans-serif;">
  <b>Plot/print style:</b>
  <input type="radio" onclick="rbCheck();" name="rb" id="rbDef"/><b>Plot</b>&nbsp;
  <input type="radio" onclick="rbCheck();" name="rb" id="rbAst"/><b>Print *</b>&nbsp;
  <input type="radio" onclick="rbCheck();" name="rb" id="rbNum"/><b>Print numbers</b>&nbsp;
  <input type="button" value="Plot it!" onclick="pspUlam();">
  <h3>Ulam Spiral</h3>
  <canvas id="cvsId" width="300" height="300" style="border: 2px inset;"></canvas>
</body>
</html>
