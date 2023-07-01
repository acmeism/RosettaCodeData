// matkronprod2.js
// Prime function:
// mkp2(): Return the Kronecker product of the a and b matrices
// Note: both a and b must be matrices, i.e., 2D rectangular arrays.
function mkp2(a,b) {
  var m=a.length, n=a[0].length, p=b.length, q=b[0].length;
  var rtn=m*p, ctn=n*q; var r=new Array(rtn);
  for (var i=0; i<rtn; i++) {r[i]=new Array(ctn)
    for (var j=0;j<ctn;j++) {r[i][j]=0}
  }
  for (var i=0; i<m; i++) {
    for (var j=0; j<n; j++) {
      for (var k=0; k<p; k++) {
        for (var l=0; l<q; l++) {
          r[p*i+k][q*j+l]=a[i][j]*b[k][l];
        }}}}//all4forend
  return(r);
}
// Helper functions:
// Log title and matrix mat to console
function matl2cons(title,mat) {console.log(title); console.log(mat.join`\n`)}
// Print title to document
function pttl2doc(title) {document.write('<b>'+title+'</b><br>')}
// Print title and matrix mat to document
function matp2doc(title,mat) {
  document.write('<b>'+title+'</b>:<br>');
  for (var i=0; i < mat.length; i++) {
    document.write('&nbsp;&nbsp;'+mat[i].join(' ')+'<br>');
  }
}
