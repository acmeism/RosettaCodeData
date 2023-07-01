  function draw() {
    var canvas = document.getElementById("container");
    context = canvas.getContext("2d");

    bezier3(20, 200, 700, 50, -300, 50, 380, 150);
//    bezier3(160, 10, 10, 40, 30, 160, 150, 110);
//    bezier3(0,149, 30,50, 120,130, 160,30, 0);
  }

  // http://rosettacode.org/wiki/Cubic_bezier_curves#C
  function bezier3(x1, y1, x2, y2, x3, y3, x4, y4) {
    var px = [], py = [];
    for (var i = 0; i <= b3Seg; i++) {
      var d = i / b3Seg;
      var a = 1 - d;
      var b = a * a;
      var c = d * d;
      a = a * b;
      b = 3 * b * d;
      c = 3 * a * c;
      d = c * d;
      px[i] = parseInt(a * x1 + b * x2 + c * x3 + d * x4);
      py[i] = parseInt(a * y1 + b * y2 + c * y3 + d * y4);
    }
    var x0 = px[0];
    var y0 = py[0];
    for (i = 1; i <= b3Seg; i++) {
      var x = px[i];
      var y = py[i];
      drawPolygon(context, [[x0, y0], [x, y]], "red", "red");
      x0 = x;
      y0 = y;
    }
  }
function drawPolygon(context, polygon, strokeStyle, fillStyle) {
  context.strokeStyle = strokeStyle;
  context.beginPath();

  context.moveTo(polygon[0][0],polygon[0][1]);
  for (i = 1; i < polygon.length; i++)
    context.lineTo(polygon[i][0],polygon[i][1]);

  context.closePath();
  context.stroke();

  if (fillStyle == undefined)
    return;
  context.fillStyle = fillStyle;
  context.fill();
}
