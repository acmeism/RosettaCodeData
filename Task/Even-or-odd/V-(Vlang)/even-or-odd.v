fn test(n i64) {
    print('Testing integer $n')

    if n&1 == 0 {
        print(' even')
    }else{
        print('  odd')
    }

    if n%2 == 0 {
        println(' even')
    }else{
        println('  odd')
    }
}

fn main(){
    test(-2)
    test(-1)
    test(0)
    test(1)
    test(2)
}
