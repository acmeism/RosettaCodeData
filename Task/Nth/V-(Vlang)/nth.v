fn ord(n int) string {
    mut s := "th"
    c := n % 10
    if c in [1,2,3] {
        if n%100/10 == 1 {
            return "$n$s"
        }
        match c {
            1 {
                s = 'st'
            }
            2 {
                s = 'nd'
            }
            3 {
                s = 'rd'
            }
            else{}
        }
    }
    return "$n$s"
}

fn main() {
    for n := 0; n <= 25; n++ {
        print("${ord(n)} ")
    }
    println('')
    for n := 250; n <= 265; n++ {
        print("${ord(n)} ")
    }
    println('')
    for n := 1000; n <= 1025; n++ {
        print("${ord(n)} ")
    }
    println('')
}
