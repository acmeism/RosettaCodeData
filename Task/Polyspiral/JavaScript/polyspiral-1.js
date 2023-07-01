<!-- Polyspiral.html -->
<html>
<head><title>Polyspiral Generator</title></head>
<script>
// Basic function for family of Polyspirals
// Where: rng - range (prime parameter), w2 - half of canvas width,
//        d - direction (1 - clockwise, -1 - counter clockwise).
function ppsp(ctx, rng, w2, d) {
  // Note: coefficients c, it, sc, sc2, sc3 are selected to fit canvas.
  var c=Math.PI*rng, it=c/w2, sc=2, sc2=50, sc3=0.1, t, x, y;
  console.log("Polyspiral PARs rng,w2,d:", rng, "/", w2, "/", d);
  if (rng>1000) {sc=sc3}
  ctx.beginPath();
  for(var i=0; i<sc2*c; i++) {
    t=it*i;
    x = sc*t*Math.cos(d*t)+w2; y = sc*t*Math.sin(d*t)+w2;
    ctx.lineTo(x, y);
  }//fend i
  ctx.stroke();
}
// ******************************************
// pspiral() - Generating and plotting Polyspirals
function pspiral() {
  // Setting basic vars for canvas and inpu parameters
  var cvs = document.getElementById('cvsId');
  var ctx = cvs.getContext("2d");
  var w = cvs.width, h = cvs.height;
  var w2=w/2;
  var clr = document.getElementById("color").value; // color
  var d = document.getElementById("dir").value;     // direction
  var rng = document.getElementById("rng").value;   // range
  rng=Number(rng);
  ctx.fillStyle="white"; ctx.fillRect(0,0,w,h);
  ctx.strokeStyle=clr;
  // Plotting spiral.
  ppsp(ctx, rng, w2, d)
}//func end
</script></head>
<body style="font-family: arial, helvatica, sans-serif;">
  <b>Color: </b>
  <select id="color">
    <option value="red">red</option>
    <option value="darkred" selected>darkred</option>
    <option value="green">green</option>
    <option value="darkgreen">darkgreen</option>
    <option value="blue">blue</option>
    <option value="navy">navy</option>
    <option value="brown">brown</option>
    <option value="maroon">maroon</option>
    <option value="black">black</option>
  </select>&nbsp;&nbsp;
  <b>Direction: </b>
  <input id="dir" value="1" type="number" min="-1" max="1" size="1">&nbsp;&nbsp;
  <b>Range: </b>
  <input id="rng" value="10" type="number" min="10" max="4000" step="10" size="4">&nbsp;&nbsp;
  <input type="button" value="Plot it!" onclick="pspiral();">&nbsp;&nbsp;<br>
  <h3>&nbsp;&nbsp;&nbsp;&nbsp;Polyspiral</h3>
  <canvas id="cvsId" width="640" height="640" style="border: 2px inset;"></canvas>
</body>
</html>
