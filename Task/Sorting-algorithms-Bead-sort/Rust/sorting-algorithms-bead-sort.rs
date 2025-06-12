fn distribute(dist: usize, list: &mut Vec<usize>) {
    // If dist exceeds current length, extend the vector with zeros
    if dist > list.len() {
        list.resize(dist, 0);
    }

    // Increment each of the first `dist` positions (simulate gravity)
    for i in 0..dist {
        list[i] += 1;
    }
}

fn bead_sort(arr: &[usize]) -> Vec<usize> {
    let mut list = Vec::new();
    let mut list2 = Vec::new();

    println!("#1 Beads falling down: ");
    for &num in arr {
        distribute(num, &mut list);
    }

    println!("\nBeads on their sides: {:?}", list);

    println!("#2 Beads right side up: ");
    for &count in &list {
        distribute(count, &mut list2);
    }

    list2
}

fn main() {
    let myints = [734, 3, 1, 24, 324, 324, 32, 432, 42, 3, 4, 1, 1];
    let sorted = bead_sort(&myints);

    println!("Sorted list/array: {:?}", sorted);
}
