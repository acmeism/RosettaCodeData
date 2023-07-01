// KPF.js 6/23/16 aev
// HFJS: Plot any matrix mat (filled with 0,1)
function pmat01(mat, color) {
  // DCLs
  var cvs = document.getElementById('canvId');
  var ctx = cvs.getContext("2d");
  var w = cvs.width; var h = cvs.height;
  var m = mat[0].length; var n = mat.length;
  // Cleaning canvas and setting plotting color
  ctx.fillStyle="white"; ctx.fillRect(0,0,w,h);
  ctx.fillStyle=color;
  // MAIN LOOP
  for(var i=0; i<m; i++) {
    for(var j=0; j<n; j++) {
      if(mat[i][j]==1) { ctx.fillRect(i,j,1,1)};
    }//fend j
  }//fend i
}//func end
// Prime functions:
// Create Kronecker product based fractal matrix rm from matrix m (order=ord)
function ckpbfmat(m,ord) {
  var rm=m;
  for(var i=1; i<ord; i++) {rm=mkp(rm,m)};
  //matpp2doc('R 4 ordd',rm,'*'); // ASCII "plotting" - if you wish to try.
  return(rm);
}
// Create and plot Kronecker product based fractal from matrix m (filled with 0/1)
function cpmat(m,ord,color) {
  var kpr;
  kpr=ckpbfmat(m,ord);
  pmat01(kpr,color);
}
// Fractal matrix "pretty" printing to document.
// mat should be filled with 0 and 1; chr is a char substituting 1.
function matpp2doc(title,mat,chr) {
  var i,j,re='',e; var m=mat.length; var n=mat[0].length;
  document.write('&nbsp;&nbsp;<b>'+title+'</b>:<pre>');
  for(var i=0; i<m; i++) {
    for(var j=0; j<n; j++) {
      e='&nbsp;'; if(mat[i][j]==1) {e=chr}; re+=e;
    }//fend j
    document.write('&nbsp;&nbsp;'+re+'<br />'); re='';
  }//fend i
  document.write('</pre>');
}
// mkp function (exotic arrow function): Return the Kronecker product
// of the a and b matrices
mkp=(a,b)=>a.map(a=>b.map(b=>a.map(y=>b.map(x=>r.push(y*x)),t.push(r=[]))),t=[])&&t;
