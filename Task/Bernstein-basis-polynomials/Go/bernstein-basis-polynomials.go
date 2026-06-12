package main

import "fmt"

func toBern2(a []float64) []float64 {
    return []float64{a[0], a[0] + a[1]/2, a[0] + a[1] + a[2]}
}

// uses de Casteljau's algorithm
func evalBern2(b []float64, t float64) float64 {
    s := 1.0 - t
    b01 := s*b[0] + t*b[1]
    b12 := s*b[1] + t*b[2]
    return s*b01 + t*b12
}

func toBern3(a []float64) []float64 {
    b := make([]float64, 4)
    b[0] = a[0]
    b[1] = a[0] + a[1]/3
    b[2] = a[0] + a[1]*2/3 + a[2]/3
    b[3] = a[0] + a[1] + a[2] + a[3]
    return b
}

// uses de Casteljau's algorithm
func evalBern3(b []float64, t float64) float64 {
    s := 1.0 - t
    b01 := s*b[0] + t*b[1]
    b12 := s*b[1] + t*b[2]
    b23 := s*b[2] + t*b[3]
    b012 := s*b01 + t*b12
    b123 := s*b12 + t*b23
    return s*b012 + t*b123
}

func bern2to3(q []float64) []float64 {
    c := make([]float64, 4)
    c[0] = q[0]
    c[1] = q[0]/3 + q[1]*2/3
    c[2] = q[1]*2/3 + q[2]/3
    c[3] = q[2]
    return c
}

// uses Horner's rule
func evalMono2(a []float64, t float64) float64 {
    return a[0] + (t * (a[1] + (t * a[2])))
}

// uses Horner's rule
func evalMono3(a []float64, t float64) float64 {
    return a[0] + (t * (a[1] + (t * (a[2] + (t * a[3])))))
}

func main() {
    pm := []float64{1, 0, 0}
    qm := []float64{1, 2, 3}
    rm := []float64{1, 2, 3, 4}
    var x, y, m float64
    fmt.Println("Subprogram(1) examples:")
    pb2 := toBern2(pm)
    qb2 := toBern2(qm)
    fmt.Printf("mono %v --> bern %v\n", pm, pb2)
    fmt.Printf("mono %v --> bern %v\n", qm, qb2)

    fmt.Println("\nSubprogram(2) examples:")
    x = 0.25
    y = evalBern2(pb2, x)
    m = evalMono2(pm, x)
    fmt.Printf("p(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 7.5
    y = evalBern2(pb2, x)
    m = evalMono2(pm, x)
    fmt.Printf("p(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 0.25
    y = evalBern2(qb2, x)
    m = evalMono2(qm, x)
    fmt.Printf("q(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 7.5
    y = evalBern2(qb2, x)
    m = evalMono2(qm, x)
    fmt.Printf("q(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)

    fmt.Println("\nSubprogram(3) examples:")
    pm = append(pm, 0)
    qm = append(qm, 0)
    pb3 := toBern3(pm)
    qb3 := toBern3(qm)
    rb3 := toBern3(rm)
    f := "mono $%v --> bern %0.14v\n"
    fmt.Printf(f, pm, pb3)
    fmt.Printf(f, qm, qb3)
    fmt.Printf(f, rm, rb3)

    fmt.Println("\nSubprogram(4) examples:")
    x = 0.25
    y = evalBern3(pb3, x)
    m = evalMono3(pm, x)
    fmt.Printf("p(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 7.5
    y = evalBern3(pb3, x)
    m = evalMono3(pm, x)
    fmt.Printf("p(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 0.25
    y = evalBern3(qb3, x)
    m = evalMono3(qm, x)
    fmt.Printf("q(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 7.5
    y = evalBern3(qb3, x)
    m = evalMono3(qm, x)
    fmt.Printf("q(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 0.25
    y = evalBern3(rb3, x)
    m = evalMono3(rm, x)
    fmt.Printf("r(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)
    x = 7.5
    y = evalBern3(rb3, x)
    m = evalMono3(rm, x)
    fmt.Printf("r(%4.2f) = %0.14g (mono %0.14g)\n", x, y, m)

    fmt.Println("\nSubprogram(5) examples:")
    pc := bern2to3(pb2)
    qc := bern2to3(qb2)
    fmt.Printf("mono %v --> bern %0.14v\n", pb2, pc)
    fmt.Printf("mono %v --> bern %0.14v\n", qb2, qc)
}
