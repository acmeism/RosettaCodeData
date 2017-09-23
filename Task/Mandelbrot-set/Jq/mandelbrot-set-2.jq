def Mandeliter( cx; cy; maxiter ):
  # [i, x, y, x^2+y^2]
  [ maxiter, 0.0, 0.0, 0.0 ]
  | do_until( .[0] == 0 or .[3] > 4;
      .[1] as $x | .[2] as $y
      | ($x * $y) as $xy
      | ($x * $x) as $xx
      | ($y * $y) as $yy
      | [ (.[0] - 1),         # i
          ($xx - $yy + cx),   # x
          ($xy + $xy + cy),   # y
          ($xx+$yy)           # xx+yy
        ] )
    | maxiter - .[0];

# width and height should be specified as the number of pixels.
# obj == { xmin: _, xmax: _, ymin: _, ymax: _ }
def Mandelbrot( obj; width; height; iterations ):
  def pixies:
    range(0; width) as $ix
    | (obj.xmin + ((obj.xmax - obj.xmin) * $ix / (width - 1))) as $x
    | range(0; height) as $iy
    | (obj.ymin + ((obj.ymax - obj.ymin) * $iy / (height - 1))) as $y
    | Mandeliter( $x; $y; iterations ) as $i
    | if $i == iterations then
        pixel($ix; $iy; 0; 0; 0; 255)
      else
        (3 * ($i|log)/((iterations - 1.0)|log)) as $c  # redness
        | if $c < 1 then
            pixel($ix;$iy; 255*$c; 0; 0; 255)
          elif $c < 2 then
            pixel($ix;$iy; 255; 255*($c-1); 0; 255)
          else
            pixel($ix;$iy; 255; 255; 255*($c-2); 255)
          end
      end;

  svg("mandelbrot"; "100%"; "100%"),
  pixies,
  "</svg>";
