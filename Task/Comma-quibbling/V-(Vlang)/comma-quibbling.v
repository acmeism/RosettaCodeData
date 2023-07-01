fn q(s []string) string {
    match s.len {
        0 {
            return '{}'
        }
        1 {
            return '{${s[0]}}'
        }
        2 {
            return '{${s[0]} and ${s[1]}}'
        }
        else{
            return '{${s[0..s.len-1].join(', ')} and ${s[s.len-1]}}'
        }
    }
}

fn main(){
    println(q([]))
    println(q(['ABC']))
    println(q(['ABC','DEF']))
    println(q(['ABC','DEF','G','H']))
}
