fn main() {
    list := ['Gary', 'Earl', 'Billy', 'Felix', 'Mary']
    for name in list {verse(name)}
}

fn verse(name string) {
    mut b, mut f, mut m, mut y :='','','',''
    mut x := name.to_lower().title()
    y = x.substr(1, x.len)
    if 'AEIOU'.contains(x[0].ascii_str()) {y = x.to_lower()}
    b = 'b' + y
    f = 'f' + y
    m = 'm' + y
    match x[0].ascii_str() {
        'B' {b = y}
        'F' {f = y}
        'M' {m = y}
        else {}
    }
    println('$x, $x, bo-$b')
    println('Banana-fana fo-$f')
    println('Fee-fi-mo-$m')
    println('$x!\n')
}
