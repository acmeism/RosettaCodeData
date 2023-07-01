fn main() {
    arrays := [['a','b','c'],['A','B','C'],['1','2','3']]
    for i in 0..arrays[0].len {
        println('${arrays[0][i]}${arrays[1][i]}${arrays[2][i]}')
    }
}
