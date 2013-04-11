SetAttributes[drawcircle, HoldFirst];
drawcircle[img_, {x0_, y0_}, r_, color_: White] :=
 Module[{f = 1 - r, ddfx = 1, ddfy = -2 r, x = 0, y = r,
   pixels = {{0, r}, {0, -r}, {r, 0}, {-r, 0}}},
  While[x < y,
   If[f >= 0, y--; ddfy += 2; f += ddfy];
   x++; ddfx += 2; f += ddfx;
   pixels = Join[pixels, {{x, y}, {x, -y}, {-x, y}, {-x, -y},
      {y, x}, {y, -x}, {-y, x}, {-y, -x}}]];
  img = ReplacePixelValue[img, {x0, y0} + # -> color & /@ pixels]]
