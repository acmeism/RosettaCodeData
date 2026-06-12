package main

import (
    "fmt"
    "math"
    "os"
)

type vector struct{ x, y, z float64 }

func (v vector) add(w vector) vector {
    return vector{v.x + w.x, v.y + w.y, v.z + w.z}
}

func (v vector) sub(w vector) vector {
    return vector{v.x - w.x, v.y - w.y, v.z - w.z}
}

func (v vector) scale(m float64) vector {
    return vector{v.x * m, v.y * m, v.z * m}
}

func (v vector) mod() float64 {
    return math.Sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}

var (
    bodies, timeSteps                    int
    masses                               []float64
    gc                                   float64
    positions, velocities, accelerations []vector
)

func initiateSystem(fileName string) error {
    file, err := os.Open(fileName)
    if err != nil {
        return err
    }
    defer file.Close()
    fmt.Fscanf(file, "%f%d%d", &gc, &bodies, &timeSteps)
    masses = make([]float64, bodies)
    positions = make([]vector, bodies)
    velocities = make([]vector, bodies)
    accelerations = make([]vector, bodies)
    for i := 0; i < bodies; i++ {
        fmt.Fscanf(file, "%f", &masses[i])
        fmt.Fscanf(file, "%f%f%f", &positions[i].x, &positions[i].y, &positions[i].z)
        fmt.Fscanf(file, "%f%f%f", &velocities[i].x, &velocities[i].y, &velocities[i].z)
    }
    return nil
}

func resolveCollisions() {
    for i := 0; i < bodies-1; i++ {
        for j := i + 1; j < bodies; j++ {
            if positions[i] == positions[j] {
                velocities[i], velocities[j] = velocities[j], velocities[i]
            }
        }
    }
}

func computeAccelerations() {
    for i := 0; i < bodies; i++ {
        accelerations[i] = vector{0, 0, 0}
        for j := 0; j < bodies; j++ {
            if i != j {
                temp := gc * masses[j] / math.Pow(positions[i].sub(positions[j]).mod(), 3)
                accelerations[i] = accelerations[i].add(positions[j].sub(positions[i]).scale(temp))
            }
        }
    }
}

func computeVelocities() {
    for i := 0; i < bodies; i++ {
        velocities[i] = velocities[i].add(accelerations[i])
    }
}

func computePositions() {
    for i := 0; i < bodies; i++ {
        positions[i] = positions[i].add(velocities[i].add(accelerations[i].scale(0.5)))
    }
}

func simulate() {
    computeAccelerations()
    computePositions()
    computeVelocities()
    resolveCollisions()
}

func printResults() {
    f := "Body %d : % 8.6f  % 8.6f  % 8.6f | % 8.6f  % 8.6f  % 8.6f\n"
    for i := 0; i < bodies; i++ {
        fmt.Printf(
            f, i+1,
            positions[i].x, positions[i].y, positions[i].z,
            velocities[i].x, velocities[i].y, velocities[i].z,
        )
    }
}

func main() {
    if len(os.Args) != 2 {
        fmt.Printf("Usage : %s <file name containing system configuration data>\n", os.Args[0])
    } else {
        err := initiateSystem(os.Args[1])
        if err != nil {
            fmt.Println(err)
            return
        }
        fmt.Print("Body   :      x          y          z    |")
        fmt.Println("     vx         vy         vz")
        for i := 0; i < timeSteps; i++ {
            fmt.Printf("\nCycle %d\n", i+1)
            simulate()
            printResults()
        }
    }
}
