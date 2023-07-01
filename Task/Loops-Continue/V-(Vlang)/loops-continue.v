fn main() {
    for i in 1..11 {
        print(i)
        if i%5==0{
            println('')
            continue
        }
        print(', ')
    }
}
