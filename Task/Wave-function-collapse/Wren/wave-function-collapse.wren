import "random" for Random

var rand = Random.new()

var blocks = [
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    1, 1, 1,
    0, 1, 0,
    0, 1, 0,
    0, 1, 1,
    0, 1, 0,
    0, 1, 0,
    1, 1, 1,
    0, 0, 0,
    0, 1, 0,
    1, 1, 0,
    0, 1, 0
]

var wfc = Fn.new { |blocks, tdim, target|
    var N   = target[0] * target[1]
    var t0  = target[0]
    var t1  = target[1]
    var adj = List.filled(4*N, 0)
    for (i in 0...t0) {
        for (j in 0...t1) {
            var k = j + t1*i
            var m = 4 * k
            adj[m  ] =     j       + t1*((t0+i-1)%t0)  /* above (1) */
            adj[m+1] = (t1+j-1)%t1 + t1*     i         /* left  (3) */
            adj[m+2] = (   j+1)%t1 + t1*     i         /* right (5) */
            adj[m+3] =     j       + t1*((   i+1)%t0)  /* below (7) */
        }
    }
    var td0 = tdim[0]
    var td1 = tdim[1]
    var td2 = tdim[2]
    var horz = List.filled(td0*td0, 0)
    for (i in 0...td0) {
        for (j in 0...td0) {
            horz[j+i*td0] = 1
            for (k in 0...td1) {
                if (blocks[0+td2*(k+td1*i)] != blocks[(td2-1)+td2*(k+td1*j)]) {
                    horz[j+i*td0] = 0
                    break
                }
            }
        }
    }
    var vert = List.filled(td0*td0, 0)
    for (i in 0...td0) {
        for (j in 0...td0) {
            vert[j+i*td0]= 1
            for (k in 0...td2) {
                if (blocks[k+td2*(0+td1*i)] != blocks[k+td2*((td2-1)+td1*j)]) {
                    vert[j+i*td0]= 0
                    break
                }
            }
        }
    }
    var stride = (td0+1) * td0
    var allow  = List.filled(4 * stride, 1)
    for (i in 0...td0) {
        for (j in 0...td0) {
            allow[           (i*td0)+j] = vert[(j*td0)+i] /* above (north) */
            allow[   stride +(i*td0)+j] = horz[(j*td0)+i] /* left  (west)  */
            allow[(2*stride)+(i*td0)+j] = horz[(i*td0)+j] /* right (east)  */
            allow[(3*stride)+(i*td0)+j] = vert[(i*td0)+j] /* below (south) */
        }
    }
    var R        = List.filled(N, td0)
    var todo     = List.filled(N, 0)
    var wave     = List.filled(N*td0, 0)
    var entropy  = List.filled(N, 0)
    var indices  = List.filled(N, 0)
    var min      = 0
    var possible = List.filled(td0, 0)
    while (true) {
        var c = 0
        for (i in 0...N) {
            if (td0 == R[i]) {
                todo[c] = i
                c = c + 1
            }
        }
        if (c == 0) break
        min = td0
        for (i in 0...c) {
            entropy[i] = 0
            for (j in 0...td0) {
                var K = 4*todo[i]
                wave[i*td0 + j] = allow[           td0*R[adj[K  ]]+j] &  /* above */
                                  allow[   stride +td0*R[adj[K+1]]+j] &  /* left  */
                                  allow[(2*stride)+td0*R[adj[K+2]]+j] &  /* right */
                                  allow[(3*stride)+td0*R[adj[K+3]]+j]    /* below */
                entropy[i] = entropy[i] + wave[i*td0 + j]
            }
            if (entropy[i] < min) min = entropy[i]
        }
        if (min == 0) {
            R = null
            break
        }
        var d = 0
        for (i in 0...c) {
            if (min == entropy[i]) {
                indices[d] = i
                d = d + 1
            }
        }
        var ndx = indices[rand.int(0, d)]
        var ind = ndx * td0
        d = 0
        for (i in 0...td0) {
            if (wave[ind+i] != 0) {
                possible[d] = i
                d = d + 1
            }
        }
        R[todo[ndx]] = possible[rand.int(0, d)]
    }
    if (!R) return null
    var tile = List.filled((1+t0*(td1-1))*(1+t1*(td2-1)), 0)
    for (i0 in 0...t0) {
        for (i1 in 0...td1) {
            for (j0 in 0...t1) {
                for (j1 in 0...td2) {
                    var t = j1 + (td2-1)*j0 + (1+t1*(td2-1))*(i1 + (td1-1)*i0)
                    tile[t] = blocks[j1 + td2*(i1 + td1*R[j0+t1*i0])]
                }
            }
        }
    }
    return tile
}

var tdims = [5, 3, 3]
var size = [8, 8]
var tile = wfc.call(blocks, tdims, size)
if (!tile) return
for (i in 0..16) {
    for (j in 0..16) {
        System.write("%(" #"[tile[j+i*17]]) ")
    }
    System.print()
}
