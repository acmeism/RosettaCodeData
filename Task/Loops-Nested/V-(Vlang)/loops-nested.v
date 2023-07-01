import rand
import rand.seed

fn main() {
    rand.seed(seed.time_seed_array(2))

    mut values := [][]int{len:10, init: []int{len:10}}
    for i in 0..values.len{
        for j in 0..values[0].len {
            values[i][j] = rand.intn(20) or {19} +1
        }
    }
outerloop:
    for i,row in values {
        println('${i:3})')
        for value in row {
            print(' ${value:3}')
            if value==20{
                break outerloop
            }
        }
        println('')
    }
}
