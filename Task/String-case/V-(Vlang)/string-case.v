fn show(s string) {
    println('string: $s len: $s.len')
    println('All upper case: ${s.to_upper()}')
    println('All lower case: ${s.to_lower()}')
    println('Title words:    ${s.title()}')
    println('')
}

fn main(){
    show('alphaBETA')
    show('alpha BETA')
    show('Ǆǈǌ')
    show("o'hare O'HARE o’hare don't")
}
