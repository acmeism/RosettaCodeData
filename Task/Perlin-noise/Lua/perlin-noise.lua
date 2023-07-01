local p = {
	151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
	140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
	247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
	57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
	74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
	60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
	65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
	200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
	52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
	207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
	119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
	129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
	218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
	81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
	184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
	222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
}

-- extending for easy access
for i = 1, #p do
	p[i+256]=p[i]
end

local function fade (t)
--	fade graph: https://www.desmos.com/calculator/d5cgqlrmem
	return t*t*t*(t*(t*6-15)+10)
end

local function lerp (t, a, b)
	return a+t*(b-a)
end

local function grad (hash, x, y, z)
	local h = hash%16
	local cases = {
		 x+y,
		-x+y,
		 x-y,
		-x-y,
	
		 x+z,
		-x+z,
		 x-z,
		-x-z,

		 y+z,
		-y+z,
		 y-z,
		-y-z,
	
		 y+x,
		-y+z,
		 y-x,
		-y-z,
	}
	return cases[h+1]
end

local function noise (x,y,z)
	local a, b, c = math.floor(x)%256, math.floor(y)%256, math.floor(z)%256 -- values in range [0, 255]
	local xx, yy, zz = x%1, y%1, z%1
	local u, v, w = fade (xx), fade (yy), fade (zz)
	local a0 = p[a+1]+b
	local a1, a2 = p[a0+1]+c, p[a0+2]+c
	local b0 = p[a+2]+b
	local b1, b2 = p[b0+1]+c, p[b0+2]+c
	local k1 = grad(p[a1+1], xx,   yy,   zz)
	local k2 = grad(p[b1+1], xx-1, yy,   zz)
	local k3 = grad(p[a2+1], xx,   yy-1, zz)
	local k4 = grad(p[b2+1], xx-1, yy-1, zz)
	local k5 = grad(p[a1+2], xx,   yy,   zz-1)
	local k6 = grad(p[b1+2], xx-1, yy,   zz-1)
	local k7 = grad(p[a2+2], xx,   yy-1, zz-1)
	local k8 = grad(p[b2+2], xx-1, yy-1, zz-1)
	return lerp(w,
		lerp(v, lerp(u, k1, k2), lerp(u, k3, k4)),
		lerp(v, lerp(u, k5, k6), lerp(u, k7, k8)))
end

print (noise(3.14, 42, 7)) -- 		 0.136919958784
print (noise(1.4142, 1.2589, 2.718)) -- -0.17245663814988
