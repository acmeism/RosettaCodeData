package main

import (
    "fmt"
    "math"
)

const (
    RE  = 6371000 // radius of earth in meters
    DD  = 0.001   // integrate in this fraction of the distance already covered
    FIN = 1e7     // integrate only to a height of 10000km, effectively infinity
)

// The density of air as a function of height above sea level.
func rho(a float64) float64 { return math.Exp(-a / 8500) }

// Converts degrees to radians
func radians(degrees float64) float64 { return degrees * math.Pi / 180 }

// a = altitude of observer
// z = zenith angle (in degrees)
// d = distance along line of sight
func height(a, z, d float64) float64 {
    aa := RE + a
    hh := math.Sqrt(aa*aa + d*d - 2*d*aa*math.Cos(radians(180-z)))
    return hh - RE
}

// Integrates density along the line of sight.
func columnDensity(a, z float64) float64 {
    sum := 0.0
    d := 0.0
    for d < FIN {
        delta := math.Max(DD, DD*d) // adaptive step size to avoid it taking forever
        sum += rho(height(a, z, d+0.5*delta)) * delta
        d += delta
    }
    return sum
}

func airmass(a, z float64) float64 {
    return columnDensity(a, z) / columnDensity(a, 0)
}

func main() {
    fmt.Println("Angle     0 m              13700 m")
    fmt.Println("------------------------------------")
    for z := 0; z <= 90; z += 5 {
        fz := float64(z)
        fmt.Printf("%2d      %11.8f      %11.8f\n", z, airmass(0, fz), airmass(13700, fz))
    }
}
