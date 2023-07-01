program mandelbrot;

  {$IFDEF FPC}
      {$MODE DELPHI}
  {$ENDIF}

const
   ixmax = 800;
   iymax = 800;
   cxmin = -2.5;
   cxmax =  1.5;
   cymin = -2.0;
   cymax =  2.0;
   maxcolorcomponentvalue = 255;
   maxiteration = 200;
   escaperadius = 2;

type
   colortype = record
      red   : byte;
      green : byte;
      blue  : byte;
   end;

var
   ix, iy      : integer;
   cx, cy      : real;
   pixelwidth  : real = (cxmax - cxmin) / ixmax;
   pixelheight : real = (cymax - cymin) / iymax;
   filename    : string = 'new1.ppm';
   comment     : string = '# ';
   outfile     : textfile;
   color       : colortype;
   zx, zy      : real;
   zx2, zy2    : real;
   iteration   : integer;
   er2         : real = (escaperadius * escaperadius);

begin
   {$I-}
   assign(outfile, filename);
   rewrite(outfile);
   if ioresult <> 0 then
   begin
      {$IFDEF FPC}
         writeln(stderr, 'Unable to open output file: ', filename);
      {$ELSE}
         writeln('ERROR: Unable to open output file: ', filename);
      {$ENDIF}
      exit;
   end;

   writeln(outfile, 'P6');
   writeln(outfile, ' ', comment);
   writeln(outfile, ' ', ixmax);
   writeln(outfile, ' ', iymax);
   writeln(outfile, ' ', maxcolorcomponentvalue);

   for iy := 1 to iymax do
   begin
      cy := cymin + (iy - 1)*pixelheight;
      if abs(cy) < pixelheight / 2 then cy := 0.0;
      for ix := 1 to ixmax do
      begin
         cx := cxmin + (ix - 1)*pixelwidth;
         zx := 0.0;
         zy := 0.0;
         zx2 := zx*zx;
         zy2 := zy*zy;
         iteration := 0;
         while (iteration < maxiteration) and (zx2 + zy2 < er2) do
         begin
            zy := 2*zx*zy + cy;
            zx := zx2 - zy2 + cx;
            zx2 := zx*zx;
            zy2 := zy*zy;
            iteration := iteration + 1;
         end;
         if iteration = maxiteration then
         begin
            color.red   := 0;
            color.green := 0;
            color.blue  := 0;
         end
         else
         begin
            color.red   := 255;
            color.green := 255;
            color.blue  := 255;
         end;
         write(outfile, chr(color.red), chr(color.green), chr(color.blue));
      end;
   end;

   close(outfile);
end.
