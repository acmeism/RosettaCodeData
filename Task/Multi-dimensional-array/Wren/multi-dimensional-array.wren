import "./fmt" for Fmt

// create a 4 dimensional list of the required size and initialize successive elements to the values 1 to 120
var m = 1
var a4 = List.filled(5, null)
for (i in 0..4) {
    a4[i] = List.filled(4, null)
    for (j in 0..3) {
        a4[i][j] = List.filled(3, null)
        for (k in 0..2) {
            a4[i][j][k] = List.filled(2, 0)
            for (l in 0..1) {
                a4[i][j][k][l] = m
                m = m + 1
            }
        }
    }
}

System.print("First element = %(a4[0][0][0][0])")  // access and print value of first element
a4[0][0][0][0] = 121                               // change value of first element
System.print()

// access and print values of all elements
for (i in 0..4) {
    for (j in 0..3) {
        for (k in 0..2) {
            for (l in 0..1) {
                Fmt.write("$4d", a4[i][j][k][l])
            }
        }
    }
}
