fn merge(in1: &[i32], in2: &[i32], out: &mut [i32]) {
    let (left, right) = out.split_at_mut(in1.len());
    left.clone_from_slice(in1);
    right.clone_from_slice(in2);
}

// least significant digit radix sort
fn radix_sort(data: &mut [i32]) {
    for bit in 0..i32::BITS - 1 {
        let (small, big): (Vec<_>, Vec<_>) = data.iter().partition(|&&x| (x >> bit) & 1 == 0);
        merge(&small, &big, data);
    }
    // lastly, handle the sign bit
    let (negative, positive): (Vec<_>, Vec<_>) = data.iter().partition(|&&x| x < 0);
    merge(&negative, &positive, data);
}

fn main() {
    let mut data = [170, 45, 75, -90, -802, 24, 2, 66, -17, 2];
    println!("Before: {:?}", data);
    radix_sort(&mut data);
    println!("After: {:?}", data);
}
