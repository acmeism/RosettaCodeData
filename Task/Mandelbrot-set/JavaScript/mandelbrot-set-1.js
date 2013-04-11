function Mandeliter(cx, cy, maxiter)
{
  var i;
  var x = 0.0;
  var y = 0.0;
  for (i = 0; i < maxiter && x*x + y*y <= 4; ++i)
  {
    var tmp = 2*x*y;
    x = x*x - y*y + cx;
    y = tmp + cy;
  }
  return i;
}

function Mandelbrot()
{
  var width = 900;
  var height = 600;
  var cd = document.getElementById('calcdata');
  var xmin = parseFloat(cd.xmin.value);
  var xmax = parseFloat(cd.xmax.value);
  var ymin = parseFloat(cd.ymin.value);
  var ymax = parseFloat(cd.ymax.value);
  var iterations = parseInt(cd.iterations.value);
  var ctx = document.getElementById('mandelimage').getContext("2d");
  var img = ctx.getImageData(0, 0, width, height);
  var pix = img.data;
  for (var ix = 0; ix < width; ++ix)
    for (var iy = 0; iy < height; ++iy)
    {
      var x = xmin + (xmax-xmin)*ix/(width-1);
      var y = ymin + (ymax-ymin)*iy/(height-1);
      var i = Mandeliter(x, y, iterations);
      var ppos = 4*(900*iy + ix);
      if (i == iterations)
      {
        pix[ppos] = 0;
        pix[ppos+1] = 0;
        pix[ppos+2] = 0;
      }
      else
      {
        var c = 3*Math.log(i)/Math.log(iterations - 1.0);
        if (c < 1)
        {
          pix[ppos] = 255*c;
          pix[ppos+1] = 0;
          pix[ppos+2] = 0;
        }
        else if (c < 2)
        {
          pix[ppos] = 255;
          pix[ppos+1] = 255*(c-1);
          pix[ppos+2] = 0;
        }
        else
        {
          pix[ppos] = 255;
          pix[ppos+1] = 255;
          pix[ppos+2] = 255*(c-2);
        }
      }
      pix[ppos+3] = 255;
    }
  ctx.putImageData(img,0,0);
}
