/ https://en.wikipedia.org/wiki/BMP_file_format
/ BITMAPINFOHEADER / RGB24

/ generate a header

genheader:{[w;h]
   0x424d, "x"$(f2i4[54+4*h*w],0,0,0,0,54,0,0,0,40,0,0,0,
                f2i4[h],f2i4[w],1,0,24,0,0,0,0,0,
                f2i4[h*((w*3)+((w*3)mod 4))],
                19,11,0,0,19,11,0,0,0,0,0,0,0,0,0,0)};

/ generate a raster line at a vertical position

genrow:{[w;y;fcn]
    row:enlist 0i;xx:0i;do[w;row,:fcn[xx;y];xx+:1i];row,:((w mod 4)#0i);1_row};

/ generate a bitmap

genbitmap:{[w;h;fcn]
    ary:enlist 0i;yy:0i;do[h;ary,:genrow[w;yy;fcn];yy+:1i];"x"$1_ary};

/ deal with endianness
/ might need to reverse last line if host computer is not a PC

f2i4:{[x] r:x;
  s0:r mod 256;r-:s0; r%:256;
  s1:r mod 256;r-:s1; r%:256;
  s2:r mod 256;r-:s2; r%:256;
  s3:r mod 256;
  "h"$(s0,s1,s2,s3)}

/ compose and write a file

writebmp:{[w;h;fcn;fn]
    fn 1: (genheader[h;w],genbitmap[w;h;fcn])};

/ / usage example:
/ w:400;
/ h:300;
/ fcn:{x0:x-w%2;y0:y-h%2;r:175;$[(r*r)>((x0*x0)+(y0*y0));(0;0;255);(0;255;0)]};
/ fn:`:demo.bmp;
/ writebmp[w;h;fcn;fn];
