<!-- SierpinskiTriangle.html -->
<html>
<head><title>Sierpinski Triangle Fractal</title>
<script>
// HF#1 Like in PARI/GP: return random number 0..max-1
function randgp(max) {return Math.floor(Math.random()*max)}
// HF#2 Random hex color
function randhclr() {
  return "#"+
  ("00"+randgp(256).toString(16)).slice(-2)+
  ("00"+randgp(256).toString(16)).slice(-2)+
  ("00"+randgp(256).toString(16)).slice(-2)
}
// HFJS#3: Plot any matrix mat (filled with 0,1)
function pmat01(mat, color) {
  // DCLs
  var cvs = document.getElementById('cvsId');
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

// Prime function
// Plotting Sierpinski triangle. aev 4/9/17
// ord - order, fn - file name, ttl - plot title, clr - color
function pSierpinskiT() {
  var cvs=document.getElementById("cvsId");
  var ctx=cvs.getContext("2d");
  var w=cvs.width, h=cvs.height;
  var R=new Array(w);
  for (var i=0; i<w; i++) {R[i]=new Array(w)
    for (var j=0; j<w; j++) {R[i][j]=0}
  }
  ctx.fillStyle="white"; ctx.fillRect(0,0,w,h);
  for (var y=0; y<w; y++) {
    for (var x=0; x<w; x++) {
      if((x & y) == 0 ) {R[x][y]=1}
  }}
  pmat01(R, randhclr());
}
</script></head>
<body style="font-family: arial, helvatica, sans-serif;">
  <b>Please click to start and/or change color: </b>
  <input type="button" value=" Plot it! " onclick="pSierpinskiT();">&nbsp;&nbsp;
  <h3>Sierpinski triangle fractal</h3>
  <canvas id="cvsId" width="640" height="640" style="border: 2px inset;"></canvas>
  <!--canvas id="cvsId" width="1280" height="1280" style="border: 2px inset;"></canvas-->
</body></html>
