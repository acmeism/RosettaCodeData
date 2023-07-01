import rand

fn main() {
    list := ["friends", "peace", "people", "happiness", "hello", "world"]
    for index in 1..list.len + 1 {println(index.str() + ': ' +  list[rand.intn(list.len) or {}])}
}
