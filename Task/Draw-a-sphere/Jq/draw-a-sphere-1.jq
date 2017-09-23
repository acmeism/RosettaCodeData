def svg:
  "<svg width='100%' height='100%' version='1.1'
    xmlns='http://www.w3.org/2000/svg'
    xmlns:xlink='http://www.w3.org/1999/xlink'>" ;

# A radial gradient to make a circle look like a sphere.
# "colors" should be [startColor, intermediateColor, endColor]
# or null for ["white", "teal", "black"]
def sphericalGradient(id; colors):
  "<defs>
        <radialGradient id = '\(id)' cx = '30%' cy = '30%' r = '100%' fx='10%' fy='10%' >
            <stop stop-color = '\(colors[0]//"white")' offset =   '0%'/>
            <stop stop-color = '\(colors[1]//"teal")'  offset =  '50%'/>
            <stop stop-color = '\(colors[1]//"black")' offset = '100%'/>
        </radialGradient>
    </defs>" ;

def sphere(cx; cy; r; gradientId):
   "<circle fill='url(#\(gradientId))' cx='\(cx)' cy='\(cy)' r='\(r)' />" ;
