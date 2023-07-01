import math

shades = ('.',':','!','*','o','e','&','#','%','@')

def normalize(v):
	len = math.sqrt(v[0]**2 + v[1]**2 + v[2]**2)
	return (v[0]/len, v[1]/len, v[2]/len)

def dot(x,y):
	d = x[0]*y[0] + x[1]*y[1] + x[2]*y[2]
	return -d if d < 0 else 0

def draw_sphere(r, k, ambient, light):
	for i in range(int(math.floor(-r)),int(math.ceil(r)+1)):
		x = i + 0.5
		line = ''

		for j in range(int(math.floor(-2*r)),int(math.ceil(2*r)+1)):
			y = j/2 + 0.5
			if x*x + y*y <= r*r:
				vec = normalize((x,y,math.sqrt(r*r - x*x - y*y)))
				b = dot(light,vec)**k + ambient
				intensity = int((1-b)*(len(shades)-1))
				line += shades[intensity] if 0 <= intensity < len(shades) else shades[0]
			else:
				line += ' '

		print(line)

light = normalize((30,30,-50))
draw_sphere(20,4,0.1, light)
draw_sphere(10,2,0.4, light)
