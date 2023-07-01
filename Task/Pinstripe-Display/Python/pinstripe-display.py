#Python task for Pinstripe/Display
#Tested for Python2.7 by Benjamin Curutchet

#Import PIL libraries
from PIL import Image
from PIL import ImageColor
from PIL import ImageDraw

#Create the picture (size parameter 1660x1005 like the example)
x_size = 1650
y_size = 1000
im = Image.new('RGB',(x_size, y_size))

#Create a full black picture
draw = ImageDraw.Draw(im)

#RGB code for the White Color
White  = (255,255,255)

#First loop in order to create four distinct lines
y_delimiter_list = []
for y_delimiter in range(1,y_size,y_size/4):
	y_delimiter_list.append(y_delimiter)


#Four different loops in order to draw columns in white depending on the
#number of the line

for x in range(1,x_size,2):
	for y in range(1,y_delimiter_list[1],1):
		draw.point((x,y),White)

for x in range(1,x_size-1,4):
	for y in range(y_delimiter_list[1],y_delimiter_list[2],1):
		draw.point((x,y),White)
		draw.point((x+1,y),White)
		
for x in range(1,x_size-2,6):
	for y in range(y_delimiter_list[2],y_delimiter_list[3],1):
		draw.point((x,y),White)
		draw.point((x+1,y),White)
		draw.point((x+2,y),White)
		
for x in range(1,x_size-3,8):
	for y in range(y_delimiter_list[3],y_size,1):
		draw.point((x,y),White)
		draw.point((x+1,y),White)
		draw.point((x+2,y),White)
		draw.point((x+3,y),White)
	
				
		
#Save the picture under a name as a jpg file.
print "Your picture is saved"		
im.save('PictureResult.jpg')
