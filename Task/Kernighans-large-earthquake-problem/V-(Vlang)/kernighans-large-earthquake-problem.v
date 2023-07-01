import os
fn main() {
    lines := os.read_lines('data.txt')?
    println('Those earthquakes with a magnitude > 6.0 are:\n')
    for line in lines {
        fields := line.fields()
        mag := fields[2].f64()
        if mag > 6.0 {
            println(line)
        }
    }
}
