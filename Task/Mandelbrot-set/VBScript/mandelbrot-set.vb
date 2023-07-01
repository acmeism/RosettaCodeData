option explicit

' Raster graphics class in VBSCRIPT by Antoni Gual
'--------------------------------------------
' An array keeps the image allowing to set pixels, draw lines and boxes in it.
' at class destroy a bmp file is saved to disk and the default viewer is called
' The class can work with 8 and 24 bit bmp. With 8 bit uses a built-in palette or can import a custom one


'Declaration :
' Set MyObj = (New ImgClass)(name,width,height, orient,bits_per_pixel,palette_array)
' name:path and name of the file created
' width, height of the canvas
' orient is the way the coord increases, 1 to 4 think of the 4 cuadrants of the caterian plane
'    1 X:l>r Y:b>t   2 X:r>l Y:b>t  3 X:r>l Y:t>b   4 X:l>r  Y:t>b
' bits_per_pixel can bs only 8 and 24
' palette array only to substitute the default palette for 8 bits, else put a 0
' it sets the origin at the corner of the image (bottom left if orient=1)

Class ImgClass
  Private ImgL,ImgH,ImgDepth,bkclr,loc,tt
  private xmini,xmaxi,ymini,ymaxi,dirx,diry
  public ImgArray()  'rgb in 24 bit mode, indexes to palette in 8 bits
  private filename
  private Palette,szpal

  Public Property Let depth (x)
  if depth=8 or depth =24 then
    Imgdepth=depth
  else
    Imgdepth=8
  end if
  bytepix=imgdepth/8
  end property

  Public Property Let Pixel (x,y,color)
  If (x>=ImgL) or x<0 then exit property
  if y>=ImgH or y<0 then exit property
  ImgArray(x,y)=Color
  End Property

  Public Property Get Pixel (x,y)
  If (x<ImgL) And (x>=0) And (y<ImgH) And (y>=0) Then
    Pixel=ImgArray(x,y)
  End If
  End Property

  Public Property Get ImgWidth ()
  ImgWidth=ImgL-1
  End Property

  Public Property Get ImgHeight ()
  ImgHeight=ImgH-1
  End Property

  'constructor (fn,w*2,h*2,32,0,0)
  Public Default Function Init(name,w,h,orient,dep,bkg,mipal)
  'offx, offy posicion de 0,0. si ofx+ , x se incrementa de izq a der, si offy+ y se incrementa de abajo arriba
  dim i,j
  ImgL=w
  ImgH=h
  tt=timer
  set0 0,0   'origin blc positive up and right
  redim imgArray(ImgL-1,ImgH-1)
  bkclr=bkg
  if bkg<>0 then
    for i=0 to ImgL-1
      for j=0 to ImgH-1
        imgarray(i,j)=bkg
      next
    next
  end if
  Select Case orient
    Case 1: dirx=1 : diry=1
    Case 2: dirx=-1 : diry=1
    Case 3: dirx=-1 : diry=-1
    Case 4: dirx=1 : diry=-1
  End select
  filename=name
  ImgDepth =dep
  'load user palette if provided
  if imgdepth=8 then
    loadpal(mipal)
  end if
  set init=me
  end function

  private sub loadpal(mipale)
    if isarray(mipale) Then
      palette=mipale
      szpal=UBound(mipale)+1
    Else
      szpal=256
    'Default palette recycled from ATARI

   End if
  End Sub
  public sub set0 (x0,y0) 'origin can be changed during drawing
    if x0<0 or x0>=imgl or y0<0 or y0>imgh then err.raise 9
    xmini=-x0
    ymini=-y0
    xmaxi=xmini+imgl-1
    ymaxi=ymini+imgh-1

  end sub


  Private Sub Class_Terminate
  if err <>0 then wscript.echo "Error " & err.number
  wscript.echo "writing bmp to file"
    savebmp
    wscript.echo "opening " & filename
    CreateObject("Shell.Application").ShellExecute filename
  wscript.echo timer-tt & " seconds"
  End Sub


 'writes a 32bit integr value as binary to an utf16 string
 function long2wstr( x)  'falta muy poco!!!
      dim k1,k2,x1
      k1=  (x and &hffff&)' or (&H8000& And ((X And &h8000&)<>0)))
      k2=((X And &h7fffffff&) \ &h10000&) Or (&H8000& And (x<0))
      long2wstr=chrw(k1) & chrw(k2)
    end function

    function int2wstr(x)
        int2wstr=ChrW((x and &h7fff) or (&H8000 And (X<0)))
    End Function


  Public Sub SaveBMP
    'Save the picture to a bmp file
    Dim s,ostream, x,y,loc

    const hdrs=54 '14+40
    dim bms:bms=ImgH* 4*(((ImgL*imgdepth\8)+3)\4)  'bitmap size including padding
    dim palsize:if (imgdepth=8) then palsize=szpal*4 else palsize=0

    with  CreateObject("ADODB.Stream") 'auxiliary ostream, it creates an UNICODE with bom stream in memory
      .Charset = "UTF-16LE"    'o "UTF16-BE"
      .Type =  2' adTypeText
      .open

      'build a header
      'bmp header: VBSCript does'nt have records nor writes binary values to files, so we use strings of unicode chars!!
      'BMP header
      .writetext ChrW(&h4d42)                           ' 0 "BM" 4d42
      .writetext long2wstr(hdrs+palsize+bms)            ' 2 fiesize
      .writetext long2wstr(0)                           ' 6  reserved
      .writetext long2wstr (hdrs+palsize)               '10 image offset
       'InfoHeader
      .writetext long2wstr(40)                          '14 infoheader size
      .writetext long2wstr(Imgl)                        '18 image length
      .writetext long2wstr(imgh)                        '22 image width
      .writetext int2wstr(1)                            '26 planes
      .writetext int2wstr(imgdepth)                     '28 clr depth (bpp)
      .writetext long2wstr(&H0)                         '30 compression used 0= NOCOMPR

      .writetext long2wstr(bms)                         '34 imgsize
      .writetext long2wstr(&Hc4e)                       '38 bpp hor
      .writetext long2wstr(&hc43)                       '42 bpp vert
      .writetext long2wstr(szpal)                       '46  colors in palette
      .writetext long2wstr(&H0)                         '50 important clrs 0=all

      'write bitmap
      'precalc data for orientation
       Dim x1,x2,y1,y2
       If dirx=-1 Then x1=ImgL-1 :x2=0 Else x1=0:x2=ImgL-1
       If diry=-1 Then y1=ImgH-1 :y2=0 Else y1=0:y2=ImgH-1

      Select Case imgdepth

      Case 32
        For y=y1 To y2  step diry
          For x=x1 To x2 Step dirx
           'writelong fic, Pixel(x,y)
           .writetext long2wstr(Imgarray(x,y))
          Next
        Next

      Case 8
        'palette
        For x=0 to szpal-1
          .writetext long2wstr(palette(x))  '52
        Next
        'image
        dim pad:pad=ImgL mod 4
        For y=y1 to y2 step diry
          For x=x1 To x2 step dirx*2
             .writetext chrw((ImgArray(x,y) and 255)+ &h100& *(ImgArray(x+dirx,y) and 255))
          Next
          'line padding
          if pad and 1 then .writetext  chrw(ImgArray(x2,y))
          if pad >1 then .writetext  chrw(0)
         Next

      Case Else
        WScript.Echo "ColorDepth not supported : " & ImgDepth & " bits"
      End Select

      'use a second stream to save to file starting past the BOM  the first ADODB.Stream has added
      Dim outf:Set outf= CreateObject("ADODB.Stream")
      outf.Type    = 1 ' adTypeBinary
      outf.Open
      .position=2              'remove bom (1 wchar)
      .CopyTo outf
      .close
      outf.savetofile filename,2   'adSaveCreateOverWrite
      outf.close
    end with
  End Sub
End Class

function mandelpx(x0,y0,maxit)
   dim x,y,xt,i,x2,y2
   i=0:x2=0:y2=0
   Do While i< maxit
     i=i+1
     xt=x2-y2+x0
     y=2*x*y+y0
     x=xt
     x2=x*x:y2=y*y
     If (x2+y2)>=4 Then Exit do
   loop
   if i=maxit then
      mandelpx=0
   else
     mandelpx = i
   end if
end function

Sub domandel(x1,x2,y1,y2)
 Dim i,ii,j,jj,pix,xi,yi,ym
 ym=X.ImgHeight\2
 'get increments in the mandel plane
 xi=Abs((x1-x2)/X.ImgWidth)
 yi=Abs((y2-0)/(X.ImgHeight\2))
 j=0
 For jj=0.  To y2 Step yi
   i=0
   For ii=x1 To x2 Step xi
      pix=mandelpx(ii,jj,256)
      'use simmetry
      X.imgarray(i,ym-j)=pix
      X.imgarray(i,ym+j)=pix
      i=i+1
   Next
   j=j+1
 next
End Sub

'main------------------------------------
Dim i,x
'custom palette
dim pp(255)
for i=1 to 255
   pp(i)=rgb(0,0,255*(i/255)^.25)  'VBS' RGB function is for the web, it's bgr for Windows BMP !!
next

dim fn:fn=CreateObject("Scripting.FileSystemObject").GetSpecialFolder(2)& "\mandel.bmp"
Set X = (New ImgClass)(fn,580,480,1,8,0,pp)
domandel -2.,1.,-1.2,1.2
Set X = Nothing
