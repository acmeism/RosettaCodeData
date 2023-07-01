# "FloodFillClean.png" is name of input file
# [55,55] the x,y coordinate where fill starts
# (0,0,0,255) the target colour being filled( black in this example )
# (255,255,255,255) the final colour ( white in this case )
img = FloodFill( "FloodFillClean.png", [55,55], (0,0,0,255), (255,255,255,255) )
#The resulting image is saved as Filled.png
img.save( "Filled.png" )
