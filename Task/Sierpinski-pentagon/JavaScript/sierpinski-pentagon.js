<html>
<head>
<script type="application/x-javascript">
// Globals
var cvs, ctx, scale=500, p0, ord=0, clr='blue', jc=0;
var clrs=['blue','navy','green','darkgreen','red','brown','yellow','cyan'];

function p5f() {
  cvs = document.getElementById("cvsid");
  ctx = cvs.getContext("2d");
  cvs.onclick=iter;
  pInit(); //init plot
}

function iter() {
  if(ord>5) {resetf(0)};
  ctx.clearRect(0,0,cvs.width,cvs.height);
  p0.forEach(iter5);
  p0.forEach(pIter5);
  ord++; document.getElementById("p1id").innerHTML=ord;
}

function iter5(v, i, a) {
  if(typeof(v[0][0]) == "object") {a[i].forEach(iter5)}
  else {a[i] = meta5(v)}
}

function pIter5(v, i, a) {
  if(typeof(v[0][0]) == "object") {v.forEach(pIter5)}
  else {pPoly(v)}
}

function pInit() {
  p0 = [make5([.5,.5], .5)];
  pPoly(p0[0]);
}

function meta5(h) {
  c=h[0]; p1=c; p2=h[1]; z1=p1[0]-p2[0]; z2=p1[1]-p2[1];
  dist = Math.sqrt(z1*z1 + z2*z2)/2.65;
  nP=[];
  for(k=1; k<h.length; k++) {
    p1=h[k]; p2=c; a=Math.atan2(p2[1]-p1[1], p2[0]-p1[0]);
    nP[k] = make5(ppad(a, dist, h[k]), dist)
  }
  nP[0]=make5(c, dist);
  return nP;
}

function make5(c, r) {
  vs=[]; j = 1;
  for(i=1/10; i<2; i+=2/5) {
    vs[j]=ppad(i*Math.PI, r, c); j++;
  }
  vs[0] = c; return vs;
}

function pPoly(s) {
  ctx.beginPath();
  ctx.moveTo(s[1][0]*scale, s[1][1]*-scale+scale);
  for(i=2; i<s.length; i++)
    ctx.lineTo(s[i][0]*scale, s[i][1]*-scale+scale);
  ctx.fillStyle=clr; ctx.fill()
}

// a - angle, d - distance, p - point
function ppad(a, d, p) {
  x=p[0]; y=p[1];
  x2=d*Math.cos(a)+x; y2=d*Math.sin(a)+y;
  return [x2,y2]
}

function resetf(rord) {
  ctx.clearRect(0,0,cvs.width,cvs.height);
  ord=rord; jc++; if(jc>7){jc=0}; clr=clrs[jc];
  document.getElementById("p1id").innerHTML=ord;
  p5f();
}
</script>
</head>
 <body onload="p5f()" style="font-family: arial, helvatica, sans-serif;">
 	<b>Click Pentaflake to iterate.</b>&nbsp; Order: <label id='p1id'>0</label>&nbsp;&nbsp;
 	<input type="submit" value="RESET" onclick="resetf(0);">&nbsp;&nbsp;
 	(Reset anytime: to start new Pentaflake and change color.)
 	<br /><br />
    <canvas id="cvsid" width=640 height=640></canvas>
 </body>
</html>
