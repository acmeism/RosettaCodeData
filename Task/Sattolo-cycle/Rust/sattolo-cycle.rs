use rand::seq::IteratorRandom;

fn sattolo_cycle<T>(items: &mut Vec<T>) -> &Vec<T> where T: Clone {
    let mut rng = rand::thread_rng();
    for i in (0..items.len()).rev() {
        let range = 0..=i;
        let j = range.choose(&mut rng).unwrap(); // 0 <= j <= i-1
        let tmpj = items[j].clone();
        items[j] = items[i].clone();
        items[i] = tmpj;
    }
    return items;
}

fn main() {
    let mut lst = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].to_vec();
    for _idx in 0..10 {
        println!("{:?}", sattolo_cycle(&mut lst));
    }
}
