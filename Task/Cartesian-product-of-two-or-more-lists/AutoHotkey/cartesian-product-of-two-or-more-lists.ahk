example := [
(join,
[[1, 2], [3, 4]]
[[3, 4], [1, 2]]
[[1, 2], []]
[[], [1, 2]]
[[1776, 1789], [7, 12], [4, 14, 23], [0, 1]]
[[1, 2, 3], [30] , [500, 100]]
[[1, 2, 3], [] , [500, 100]]
)]

for i, obj in example
{
    Product := CartesianProduct(obj)
    out := dispRes(Product)
    result .= out "`n`n"
}
MsgBox % result
return

dispRes(Product){
    for i, o in Product
    {
        for j, v in o
            output .= v ", "

        output := Trim(output, ", ")
        output .= "], ["
    }
    return "[[" trim(output, ", []") "]]"
}

CartesianProduct(obj){
    CP(obj, Product:=[], [])
    return Product
}

CP(obj, Product, stack, v:=""){
    oClone := obj.clone()
    oClone.RemoveAt(1)
    stack.= v ","

    for i, o in obj
    {
        for j, v in o
            CP(oClone, Product, stack, v)
        return
    }
    stack := trim(stack, ",")
    oTemp := []
    for i, v in StrSplit(stack, ",")
        oTemp.Push(v)
    Product.push(oTemp)
}
