bitmap = Allocate_Bitmap( 100, 50 )
Fill_Bitmap( bitmap, { 15, 200, 80 } )
pixel = Get_Pixel( bitmap, 20, 25 )
print( pixel[1], pixel[2], pixel[3] )
