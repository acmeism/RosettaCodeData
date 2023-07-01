((3d)..(0d)).each { i ->
    ((2d)..(0d)).each { j ->
        println "${i}/${j} divides by zero? " + dividesByZero(i,j)
    }
}
