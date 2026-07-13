let
  maxIterations = 50;
  inMandelbrot =
    cRe: cIm:
    let
      iter =
        n: zRe: zIm:
        let
          zRe2 = zRe * zRe;
          zIm2 = zIm * zIm;
        in
        if zRe2 + zIm2 >= 4.0 then
          false
        else if n == maxIterations then
          true
        else
          iter (n + 1) (zRe2 - zIm2 + cRe) (2.0 * zRe * zIm + cIm);
    in
    iter 0 0.0 0.0;

  yCount = 41;
  xCount = 80;

  renderRow =
    yIdx:
    let
      y = 1.0 - (yIdx * 0.05);
      renderCol =
        xIdx:
        let
          x = -2.0 + (xIdx * 0.0315);
        in
        if inMandelbrot x y then "*" else " ";
    in
    builtins.concatStringsSep "" (builtins.genList renderCol xCount);

  mandelbrotStr = builtins.concatStringsSep "\n" (builtins.genList renderRow yCount);

in
builtins.toFile "mandelbrot.txt" (mandelbrotStr + "\n")
