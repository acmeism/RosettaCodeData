package main

import (
        "flag"
        "fmt"
        "math"
        "runtime"
        "sort"
)

// Note, the standard "image" package has Point and Rectangle but we
// can't use them here since they're defined using int rather than
// float64.

type Circle struct{ X, Y, R, rsq float64 }

func NewCircle(x, y, r float64) Circle {
        // We pre-calculate r² as an optimization
        return Circle{x, y, r, r * r}
}

func (c Circle) ContainsPt(x, y float64) bool {
        return distSq(x, y, c.X, c.Y) <= c.rsq
}

func (c Circle) ContainsC(c2 Circle) bool {
        return distSq(c.X, c.Y, c2.X, c2.Y) <= (c.R-c2.R)*(c.R-c2.R)
}

func (c Circle) ContainsR(r Rect) (full, corner bool) {
        nw := c.ContainsPt(r.NW())
        ne := c.ContainsPt(r.NE())
        sw := c.ContainsPt(r.SW())
        se := c.ContainsPt(r.SE())
        return nw && ne && sw && se, nw || ne || sw || se
}

func (c Circle) North() (float64, float64) { return c.X, c.Y + c.R }
func (c Circle) South() (float64, float64) { return c.X, c.Y - c.R }
func (c Circle) West() (float64, float64)  { return c.X - c.R, c.Y }
func (c Circle) East() (float64, float64)  { return c.X + c.R, c.Y }

type Rect struct{ X1, Y1, X2, Y2 float64 }

func (r Rect) Area() float64          { return (r.X2 - r.X1) * (r.Y2 - r.Y1) }
func (r Rect) NW() (float64, float64) { return r.X1, r.Y2 }
func (r Rect) NE() (float64, float64) { return r.X2, r.Y2 }
func (r Rect) SW() (float64, float64) { return r.X1, r.Y1 }
func (r Rect) SE() (float64, float64) { return r.X2, r.Y1 }

func (r Rect) Centre() (float64, float64) {
        return (r.X1 + r.X2) / 2.0, (r.Y1 + r.Y2) / 2.0
}

func (r Rect) ContainsPt(x, y float64) bool {
        return r.X1 <= x && x < r.X2 &&
                r.Y1 <= y && y < r.Y2
}

func (r Rect) ContainsPC(c Circle) bool { //  only N,W,E,S points of circle
        return r.ContainsPt(c.North()) ||
                r.ContainsPt(c.South()) ||
                r.ContainsPt(c.West()) ||
                r.ContainsPt(c.East())
}

func (r Rect) MinSide() float64 {
        return math.Min(r.X2-r.X1, r.Y2-r.Y1)
}

func distSq(x1, y1, x2, y2 float64) float64 {
        Δx, Δy := x2-x1, y2-y1
        return (Δx * Δx) + (Δy * Δy)
}

type CircleSet []Circle

// sort.Interface for sorting by radius big to small:
func (s CircleSet) Len() int           { return len(s) }
func (s CircleSet) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }
func (s CircleSet) Less(i, j int) bool { return s[i].R > s[j].R }

func (sp *CircleSet) RemoveContainedC() {
        s := *sp
        sort.Sort(s)
        for i := 0; i < len(s); i++ {
                for j := i + 1; j < len(s); {
                        if s[i].ContainsC(s[j]) {
                                s[j], s[len(s)-1] = s[len(s)-1], s[j]
                                s = s[:len(s)-1]
                        } else {
                                j++
                        }
                }
        }
        *sp = s
}

func (s CircleSet) Bounds() Rect {
        x1 := s[0].X - s[0].R
        x2 := s[0].X + s[0].R
        y1 := s[0].Y - s[0].R
        y2 := s[0].Y + s[0].R
        for _, c := range s[1:] {
                x1 = math.Min(x1, c.X-c.R)
                x2 = math.Max(x2, c.X+c.R)
                y1 = math.Min(y1, c.Y-c.R)
                y2 = math.Max(y2, c.Y+c.R)
        }
        return Rect{x1, y1, x2, y2}
}

var nWorkers = 4

func (s CircleSet) UnionArea(ε float64) (min, max float64) {
        sort.Sort(s)
        stop := make(chan bool)
        inside := make(chan Rect)
        outside := make(chan Rect)
        unknown := make(chan Rect, 5e7) // XXX

        for i := 0; i < nWorkers; i++ {
                go s.worker(stop, unknown, inside, outside)
        }
        r := s.Bounds()
        max = r.Area()
        unknown <- r
        for max-min > ε {
                select {
                case r = <-inside:
                        min += r.Area()
                case r = <-outside:
                        max -= r.Area()
                }
        }
        close(stop)
        return min, max
}

func (s CircleSet) worker(stop <-chan bool, unk chan Rect, in, out chan<- Rect) {
        for {
                select {
                case <-stop:
                        return
                case r := <-unk:
                        inside, outside := s.CategorizeR(r)
                        switch {
                        case inside:
                                in <- r
                        case outside:
                                out <- r
                        default:
                                // Split
                                midX, midY := r.Centre()
                                unk <- Rect{r.X1, r.Y1, midX, midY}
                                unk <- Rect{midX, r.Y1, r.X2, midY}
                                unk <- Rect{r.X1, midY, midX, r.Y2}
                                unk <- Rect{midX, midY, r.X2, r.Y2}
                        }
                }
        }
}

func (s CircleSet) CategorizeR(r Rect) (inside, outside bool) {
        anyCorner := false
        for _, c := range s {
                full, corner := c.ContainsR(r)
                if full {
                        return true, false // inside
                }
                anyCorner = anyCorner || corner
        }
        if anyCorner {
                return false, false // uncertain
        }
        for _, c := range s {
                if r.ContainsPC(c) {
                        return false, false // uncertain
                }
        }
        return false, true // outside
}

func main() {
        flag.IntVar(&nWorkers, "workers", nWorkers, "how many worker go routines to use")
        maxproc := flag.Int("cpu", runtime.NumCPU(), "GOMAXPROCS setting")
        flag.Parse()

        if *maxproc > 0 {
                runtime.GOMAXPROCS(*maxproc)
        } else {
                *maxproc = runtime.GOMAXPROCS(0)
        }

        circles := CircleSet{
                NewCircle(1.6417233788, 1.6121789534, 0.0848270516),
                NewCircle(-1.4944608174, 1.2077959613, 1.1039549836),
                NewCircle(0.6110294452, -0.6907087527, 0.9089162485),
                NewCircle(0.3844862411, 0.2923344616, 0.2375743054),
                NewCircle(-0.2495892950, -0.3832854473, 1.0845181219),
                NewCircle(1.7813504266, 1.6178237031, 0.8162655711),
                NewCircle(-0.1985249206, -0.8343333301, 0.0538864941),
                NewCircle(-1.7011985145, -0.1263820964, 0.4776976918),
                NewCircle(-0.4319462812, 1.4104420482, 0.7886291537),
                NewCircle(0.2178372997, -0.9499557344, 0.0357871187),
                NewCircle(-0.6294854565, -1.3078893852, 0.7653357688),
                NewCircle(1.7952608455, 0.6281269104, 0.2727652452),
                NewCircle(1.4168575317, 1.0683357171, 1.1016025378),
                NewCircle(1.4637371396, 0.9463877418, 1.1846214562),
                NewCircle(-0.5263668798, 1.7315156631, 1.4428514068),
                NewCircle(-1.2197352481, 0.9144146579, 1.0727263474),
                NewCircle(-0.1389358881, 0.1092805780, 0.7350208828),
                NewCircle(1.5293954595, 0.0030278255, 1.2472867347),
                NewCircle(-0.5258728625, 1.3782633069, 1.3495508831),
                NewCircle(-0.1403562064, 0.2437382535, 1.3804956588),
                NewCircle(0.8055826339, -0.0482092025, 0.3327165165),
                NewCircle(-0.6311979224, 0.7184578971, 0.2491045282),
                NewCircle(1.4685857879, -0.8347049536, 1.3670667538),
                NewCircle(-0.6855727502, 1.6465021616, 1.0593087096),
                NewCircle(0.0152957411, 0.0638919221, 0.9771215985),
        }
        fmt.Println("Starting with", len(circles), "circles.")
        circles.RemoveContainedC()
        fmt.Println("Removing redundant ones leaves", len(circles), "circles.")
        fmt.Println("Using", nWorkers, "workers with maxprocs =", *maxproc)
        const ε = 0.0001
        min, max := circles.UnionArea(ε)
        avg := (min + max) / 2.0
        rng := max - min
        fmt.Printf("Area = %v±%v\n", avg, rng)
        fmt.Printf("Area ≈ %.*f\n", 5, avg)
}
