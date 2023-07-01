package raster

import "math"

func (g *Grmap) KernelFilter3(k []float64) *Grmap {
    if len(k) != 9 {
        return nil
    }
    r := NewGrmap(g.cols, g.rows)
    r.Comments = append([]string{}, g.Comments...)
    // Filter edge pixels with minimal code.
    // Execution time per pixel is high but there are few edge pixels
    // relative to the interior.
    o3 := [][]int{
        {-1, -1}, {0, -1}, {1, -1},
        {-1, 0}, {0, 0}, {1, 0},
        {-1, 1}, {0, 1}, {1, 1}}
    edge := func(x, y int) uint16 {
        var sum float64
        for i, o := range o3 {
            c, ok := g.GetPx(x+o[0], y+o[1])
            if !ok {
                c = g.pxRow[y][x]
            }
            sum += float64(c) * k[i]
        }
        return uint16(math.Min(math.MaxUint16, math.Max(0,sum)))
    }
    for x := 0; x < r.cols; x++ {
        r.pxRow[0][x] = edge(x, 0)
        r.pxRow[r.rows-1][x] = edge(x, r.rows-1)
    }
    for y := 1; y < r.rows-1; y++ {
        r.pxRow[y][0] = edge(0, y)
        r.pxRow[y][r.cols-1] = edge(r.cols-1, y)
    }
    if r.rows < 3 || r.cols < 3 {
        return r
    }

    // Interior pixels can be filtered much more efficiently.
    otr := -g.cols + 1
    obr := g.cols + 1
    z := g.cols + 1
    c2 := g.cols - 2
    for y := 1; y < r.rows-1; y++ {
        tl := float64(g.pxRow[y-1][0])
        tc := float64(g.pxRow[y-1][1])
        tr := float64(g.pxRow[y-1][2])
        ml := float64(g.pxRow[y][0])
        mc := float64(g.pxRow[y][1])
        mr := float64(g.pxRow[y][2])
        bl := float64(g.pxRow[y+1][0])
        bc := float64(g.pxRow[y+1][1])
        br := float64(g.pxRow[y+1][2])
        for x := 1; ; x++ {
            r.px[z] = uint16(math.Min(math.MaxUint16, math.Max(0,
                tl*k[0] + tc*k[1] + tr*k[2] +
                ml*k[3] + mc*k[4] + mr*k[5] +
                bl*k[6] + bc*k[7] + br*k[8])))
            if x == c2 {
                break
            }
            z++
            tl, tc, tr = tc, tr, float64(g.px[z+otr])
            ml, mc, mr = mc, mr, float64(g.px[z+1])
            bl, bc, br = bc, br, float64(g.px[z+obr])
        }
        z += 3
    }
    return r
}
