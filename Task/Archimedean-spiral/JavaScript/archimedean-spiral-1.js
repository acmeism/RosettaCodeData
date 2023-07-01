<!-- ArchiSpiral.html -->
<html>
<head><title>Archimedean spiral</title></head>
<body onload="pAS(35,'navy');">
<h3>Archimedean spiral</h3> <p id=bo></p>
<canvas id="canvId" width="640" height="640" style="border: 2px outset;"></canvas>
<script>
// Plotting Archimedean_spiral aev 3/17/17
// lps - number of loops, clr - color.
function pAS(lps,clr) {
  var a=.0,ai=.1,r=.0,ri=.1,as=lps*2*Math.PI,n=as/ai;
  var cvs=document.getElementById("canvId");
  var ctx=cvs.getContext("2d");
  ctx.fillStyle="white"; ctx.fillRect(0,0,cvs.width,cvs.height);
  var x=y=0, s=cvs.width/2;
  ctx.beginPath();
  for (var i=1; i<n; i++) {
    x=r*Math.cos(a), y=r*Math.sin(a);
    ctx.lineTo(x+s,y+s);
    r+=ri; a+=ai;
  }//fend i
  ctx.strokeStyle = clr; ctx.stroke();
}
</script></body></html>
