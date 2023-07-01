// Plot Fibonacci word/fractal
// FiboWFractal.js - 6/27/16 aev
function pFibowFractal(n,len,canvasId,color) {
  // DCLs
  var canvas = document.getElementById(canvasId);
  var ctx = canvas.getContext("2d");
  var w = canvas.width; var h = canvas.height;
  var fwv,fwe,fn,tx,x=10,y=10,dx=len,dy=0,nr;
  // Cleaning canvas, setting plotting color, etc
  ctx.fillStyle="white"; ctx.fillRect(0,0,w,h);
  ctx.beginPath();
  ctx.moveTo(x,y);
  fwv=fibword(n); fn=fwv.length;
  // MAIN LOOP
  for(var i=0; i<fn; i++) {
    ctx.lineTo(x+dx,y+dy); fwe=fwv[i];
    if(fwe=="0") {tx=dx; nr=i%2;
      if(nr==0) {dx=-dy;dy=tx} else {dx=dy;dy=-tx}};
    x+=dx; y+=dy;
  }//fend i
  ctx.strokeStyle = color; ctx.stroke();
}//func end
// Create and return Fibonacci word
function fibword(n) {
  var f1="1",f2="0",fw,fwn,n2,i;
  if (n<5) {n=5}; n2=n+2;
  for (i=0; i<n2; i++) {fw=f2+f1;f1=f2;f2=fw};
  return(fw)
}
