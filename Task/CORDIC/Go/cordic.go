package main

import (
	"fmt"
	"math"
)

// Constants
var angles = []float64{
	0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
	0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
	0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
	0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
	0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
	0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
	0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058,
}

var kvalues = []float64{
	0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
	0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
	0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
	0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
	0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
	0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888,
}

// Convert degrees to radians
func radians(degrees float64) float64 {
	return degrees * math.Pi / 180.0
}

// Cordic algorithm implementation
func cordic(alpha float64, n int, result []float64) {
	var i, sigma int
	var kn, x, y, atn, t, theta, pow2 float64 = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
	
	newsgn := -1
	if int(math.Floor(alpha/(2.0*math.Pi)))%2 == 1 {
		newsgn = 1
	}
	
	if alpha < -math.Pi/2.0 || alpha > math.Pi/2.0 {
		if alpha < 0 {
			cordic(alpha+math.Pi, n, result)
		} else {
			cordic(alpha-math.Pi, n, result)
		}
		result[0] = result[0] * float64(newsgn)
		result[1] = result[1] * float64(newsgn)
		return
	}
	
	ix := n - 1
	if ix > 23 {
		ix = 23
	}
	kn = kvalues[ix]
	x = 1
	y = 0
	
	for i = 0; i < n; i++ {
		atn = angles[i]
		if theta < alpha {
			sigma = 1
		} else {
			sigma = -1
		}
		theta += float64(sigma) * atn
		t = x
		x -= float64(sigma) * y * pow2
		y += float64(sigma) * t * pow2
		pow2 /= 2.0
	}
	
	result[0] = x * kn
	result[1] = y * kn
}

func main() {
	var c_cos, c_sin float64
	result := make([]float64, 2)
	testAngles := []float64{-9.0, 0.0, 1.5, 6.0}
	
	fmt.Println("  x       sin(x)     diff. sine     cos(x)    diff. cosine")
	format := "%+03d.0°  %+.8f (%+.8f) %+.8f (%+.8f)\n"
	
	for th := -90; th <= +90; th += 15 {
		thr := radians(float64(th))
		cordic(thr, 24, result)
		c_cos = result[0]
		c_sin = result[1]
		fmt.Printf(format, th, c_sin, c_sin-math.Sin(thr), c_cos, c_cos-math.Cos(thr))
	}
	
	fmt.Println("\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine")
	format = "%+4.1f    %+.8f (%+.8f) %+.8f (%+.8f)\n"
	
	for _, thr := range testAngles {
		cordic(thr, 24, result)
		c_cos = result[0]
		c_sin = result[1]
		fmt.Printf(format, thr, c_sin, c_sin-math.Sin(thr), c_cos, c_cos-math.Cos(thr))
	}
}
