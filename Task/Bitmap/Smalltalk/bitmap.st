|img1 img2|
"a depth24 RGB image"
img1 := Image width:100 height:200 depth:24.
img1 fillRectangle:(0@0 corner:100@100) with:Color red.
img1 fillRectangle:(0@100 corner:100@100) with:(Color rgbValue: 16rFF00FF).
img1 colorAt:(10 @ 10) put:(Color green).
img1 saveOn:'sampleFile.png'.

img1 displayOn:Transcript window graphicsContext.
Transcript showCR:(img1 colorAt:(100 @ 10) ).

"a depth8 palette image"
img2 := Image width:100 height:200 depth:8.
img2 colorMap:{ Color black. Color red . Color green }.
img2 fillRectangle:(0@0 corner:100@100) with:Color red.
img2 fillRectangle:(0@100 corner:100@100) with: 16r02.
img2 colorAt:(10 @ 10) put:(Color green).
img2 saveOn:'sampleFile.gif'.

img2 displayOn:Transcript window graphicsContext.
Transcript showCR:(img2 colorAt:(100 @ 10) ).
