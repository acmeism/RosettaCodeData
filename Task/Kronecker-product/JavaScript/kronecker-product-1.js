// matkronprod.js
// Prime function:
// mkp arrow function: Return the Kronecker product of the a and b matrices.
// Note: both a and b must be matrices, i.e., 2D rectangular arrays.
mkp=(a,b)=>a.map(a=>b.map(b=>a.map(y=>b.map(x=>r.push(y*x)),t.push(r=[]))),t=[])&&t;
// Helper functions:
// Log title and matrix mat to console
function matl2cons(title,mat) {console.log(title); console.log(mat.join`\n`)}
// Print title to document
function pttl2doc(title) {document.write('<b>'+title+'</b><br />')}
// Print title and matrix mat to document
function matp2doc(title,mat) {
  document.write('<b>'+title+'</b>:<br />');
  for (var i = 0; i < mat.length; i++) {
    document.write('&nbsp;&nbsp;'+mat[i].join(' ')+'<br />');
  }
}
