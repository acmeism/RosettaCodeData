fn main() {
    let doors = vec![false; 100].iter_mut().enumerate()
                                .map(|(door, door_state)| (1..100).into_iter()
                                                                   .filter(|pass| door % pass == 0)
                                                                   .map(|_| { *door_state = !*door_state; *door_state })
                                                                   .last().unwrap()).collect::<Vec<_>>();

    println!("{:?}", doors);
}
