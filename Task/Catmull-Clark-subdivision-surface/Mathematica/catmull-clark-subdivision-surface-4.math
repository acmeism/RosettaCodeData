faces = Delete[faces, 6];
Function[iteration, Graphics3D[
    (Polygon[iteration[[1]][[#]]] & /@ iteration[[2]])
    ]] /@ NestList[CatMullClark, {points, faces}, 3] // GraphicsRow
