<!-- DragonCurve.html -->
<html>
<head>
<script type='text/javascript'>
function pDragon(cId) {
  // Plotting Dragon curves. 2/25/17 aev
  var n=document.getElementById('ord').value;
  var sc=document.getElementById('sci').value;
  var hsh=document.getElementById('hshi').value;
  var vsh=document.getElementById('vshi').value;
  var clr=document.getElementById('cli').value;
  var c=c1=c2=c2x=c2y=x=y=0, d=1, n=1<<n;
  var cvs=document.getElementById(cId);
  var ctx=cvs.getContext("2d");
  hsh=Number(hsh); vsh=Number(vsh);
  x=y=cvs.width/2;
  // Cleaning canvas, init plotting
  ctx.fillStyle="white"; ctx.fillRect(0,0,cvs.width,cvs.height);
  ctx.beginPath();
  for(i=0; i<=n;) {
    ctx.lineTo((x+hsh)*sc,(y+vsh)*sc);
    c1=c&1; c2=c&2;
    c2x=1*d; if(c2>0) {c2x=(-1)*d}; c2y=(-1)*c2x;
    if(c1>0) {y+=c2y} else {x+=c2x}
    i++; c+=i/(i&-i);
  }
  ctx.strokeStyle = clr;  ctx.stroke();
}
</script>
</head>
<body>
<p><b>Please input order, scale, x-shift, y-shift, color:</></p>
<input id=ord value=11 type="number" min="7" max="25" size="2">
<input id=sci value=7.0 type="number" min="0.001" max="10" size="5">
<input id=hshi value=-265 type="number" min="-50000" max="50000" size="6">
<input id=vshi value=-260 type="number" min="-50000" max="50000" size="6">
<input id=cli value="red" type="text" size="14">
<button onclick="pDragon('canvId')">Plot it!</button>
<h3>Dragon curve</h3>
<canvas id="canvId" width=640 height=640 style="border: 2px inset;"></canvas>
</body>
</html>
