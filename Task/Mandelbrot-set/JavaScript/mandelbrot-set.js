function Mandeliter( cx, cy, maxiter ){
  var
    x = 0.0,
    y = 0.0,
    xx = 0,
    yy = 0,
    xy = 0;

  var i = maxiter;
  while( i-- && xx + yy <= 4 ){
    xy = x * y;
    xx = x * x;
    yy = y * y;
    x = xx - yy + cx;
    y = xy + xy + cy;
  }
  return maxiter - i;
}

function Mandelbrot( width,height, xmin,xmax, ymin,ymax, iterations ){
  var canvas = document.createElement( 'canvas' );
  canvas.width = width;
  canvas.height = height;

  var ctx = canvas.getContext( '2d' );
  var img = ctx.getImageData( 0, 0, width, height );
  var pix = img.data;
  for( var ix = 0; ix < width; ++ix )
    for( var iy = 0; iy < height; ++iy )
    {
      var x = xmin + (xmax - xmin) * ix / (width - 1);
      var y = ymin + (ymax - ymin) * iy / (height - 1);
      var i = Mandeliter( x, y, iterations );
      var ppos = 4 * (width * iy + ix);
      if( i === iterations )
      {
        pix[ppos] = 0;
        pix[ppos+1] = 0;
        pix[ppos+2] = 0;
      }
      else
      {
        var c = 3 * Math.log(i)/Math.log(iterations - 1.0);
        if (c < 1)
        {
          pix[ppos] = 255*c;
          pix[ppos+1] = 0;
          pix[ppos+2] = 0;
        }
        else if( c < 2 )
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
      pix[ ppos+3 ] = 255;
    }
  ctx.putImageData( img, 0,0 );
  document.body.insertBefore( canvas, document.body.childNodes[0] );
}

Mandelbrot( 900,600, -2,1, -1,1, 1000 );
