/* REXX ***************************************************************
* Draw a picture from pixels
* 16.06.2014 Walter Pachl
**********************************************************************/
oid='pic.bmp'; 'erase' oid

blue ='FF0000'x;
green='00FF00'x;
red  ='0000FF'x;
white='ffffff'x;
black='000000'x;

w=600                        /* width  */
h=300                        /* height */
w3=w*3

bfType         ='BM'
bfSize         ='46000000'x
bfReserved     ='00000000'x
bfOffBits      ='36000000'x
biSize         ='28000000'x
biWidth        =lend(w)
biHeight       =lend(h)
biPlanes       ='0100'x
biBitCount     ='1800'x
biCompression  ='00000000'x
biSizeImage    ='10000000'x
biXPelsPerMeter='00000000'x
biYPelsPerMeter='00000000'x
biClrUsed      ='00000000'x
biClrImportant ='00000000'x

s=bfType||,
  bfSize||,
  bfReserved||,
  bfOffBits||,
  biSize||,
  biWidth||,
  biHeight||,
  biPlanes||,
  biBitCount||,
  biCompression||,
  biSizeImage||,
  biXPelsPerMeter||,
  biYPelsPerMeter||,
  biClrUsed||,
  biClrImportant

pic=copies(red,w*h)             /* fill the rectangle with color red */
Call rect 100,100,180,180,green /* draw a green rectangle            */
Call rect 100,100,160,160,blue  /* and a blue rectangle within that  */
Call dot 120,120,white          /* one pixel is hardly visible       */
Do x=98 To 102                  /* draw a square of 25 pixels        */
  Do y=98 To 102
    Call dot x,y,white
    End
  End
Call charout oid,s||pic         /* write the picture to file         */
dmy=col(97,98)
dmy=col(98,98)
Exit

lend: Procedure
/**********************************************************************
* compute the representation of a number (little endian)
**********************************************************************/
Parse Arg n
res=reverse(d2c(n,4))
rev=reverse(res)
say 'lend:' arg(1) '->' c2x(res) '=>' c2d(rev)
Return res

rect: Procedure Expose pic w h w3
/**********************************************************************
* Fill a rectangle with center at x,y and width/height = wr/hr
**********************************************************************/
Parse Arg x,y,wr,hr,color
Say x y wr hr c2x(color)
i=w3*(y-1)+3*(x-1)+1               /* Pixel position of center       */
ia=max(w3*(y-1)+1,i-3*(wr%2))      /* position of left border        */
ib=min(i+3*wr%2,w3*y)              /* position of right border       */
lc=ib-ia                           /* length of horizontal line      */
If lc>=0 Then Do
  os=copies(color,lc%3)            /* the horizontal line            */
  Do hi=-hr%2 to hr%2              /* loop from lower to upper border*/
    i=trunc(ia+w3*hi)              /* position of line's left border */
    If i>1 Then Do
      pic=overlay(os,pic,i)        /* put the line into the picture  */
      j=i%w3
      End
    End
  End
Return

dot: Procedure Expose pic w h w3
/**********************************************************************
* Put a dot at position x/y into the picture
**********************************************************************/
Parse Arg x,y,color
i=w3*(y-1)+3*(x-1)
pic=overlay(color,pic,i+1)
Return

col: Procedure Expose pic w h w3
/**********************************************************************
* get the color at position x/y
**********************************************************************/
Parse Arg x,y,color
i=w3*(y-1)+3*(x-1)
say 'color at pixel' x'/'y'='c2x(substr(pic,i+1,3))
Return c2x(substr(pic,i+1,3))
