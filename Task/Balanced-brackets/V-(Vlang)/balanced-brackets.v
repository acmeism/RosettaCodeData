import datatypes as dt

fn is_valid(bracket string) bool {
    mut s := dt.Stack<string>{}
    for b in bracket.split('') {
        if b == '[' {
            s.push(b)
        } else {
            if s.peek() or {''} == '[' {
                s.pop() or {panic("WON'T GET HERE EVER")}
            } else {
                return false
            }
        }
    }
    return true
}

fn main() {
    brackets := ['','[]','[][]','[[][]]','][','][][','[]][[]','[][[][[]][][[][]]]']
    for b in brackets {
        println('$b ${is_valid(b)}')
    }
}
