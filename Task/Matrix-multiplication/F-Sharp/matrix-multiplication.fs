let MatrixMultiply (matrix1 : _[,] , matrix2 : _[,]) =
    let result_row = (matrix1.GetLength 0)
    let result_column = (matrix2.GetLength 1)
    let ret = Array2D.create result_row result_column 0
    for x in 0 .. result_row - 1 do
        for y in 0 .. result_column - 1 do
            let mutable acc = 0
            for z in 0 .. (matrix1.GetLength 1) - 1 do
                acc <- acc + matrix1.[x,z] * matrix2.[z,y]
            ret.[x,y] <- acc
    ret
