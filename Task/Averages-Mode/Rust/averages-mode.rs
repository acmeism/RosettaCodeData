use std::collections::HashMap;

fn main() {
    let mode_vec1 = mode(vec![ 1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17]);
    let mode_vec2 = mode(vec![ 1, 1, 2, 4, 4]);

    println!("Mode of vec1 is: {:?}", mode_vec1);
    println!("Mode of vec2 is: {:?}", mode_vec2);

    assert!( mode_vec1 == [6], "Error in mode calculation");
    assert!( (mode_vec2 == [1, 4]) || (mode_vec2 == [4,1]), "Error in mode calculation" );
}

fn mode(vs: Vec<i32>) -> Vec<i32> {
    let mut vec_mode = Vec::new();
    let mut seen_map = HashMap::new();
    let mut max_val = 0;
    for i in vs{
        let ctr = seen_map.entry(i).or_insert(0);
        *ctr += 1;
        if *ctr > max_val{
            max_val = *ctr;
        }
    }
    for (key, val) in seen_map {
        if val == max_val{
            vec_mode.push(key);
        }
    }
    vec_mode
}
