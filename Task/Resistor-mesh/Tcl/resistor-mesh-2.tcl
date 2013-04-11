ResistorMesh create mesh {
    size  {10 10}
    fixed {1 1  1.0}
    fixed {6 7 -1.0}
}
puts [format "R = %.12g" [mesh solveForResistance]]
