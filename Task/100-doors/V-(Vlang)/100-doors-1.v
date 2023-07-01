const number_doors = 101

fn main() {
    mut closed_doors := []bool{len: number_doors, init: true}
    for pass in 0..number_doors {
        for door := 0; door < number_doors; door += pass + 1 {
            closed_doors[door] = !closed_doors[door]
        }
    }
    for pass in 1..number_doors {
        if !closed_doors[pass] {
            println('Door #$pass Open')
        }
    }
}
