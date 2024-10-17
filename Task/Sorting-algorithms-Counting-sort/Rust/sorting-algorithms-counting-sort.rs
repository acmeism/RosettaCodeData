fn counting_sort(
    mut data: Vec<usize>,
    min: usize,
    max: usize,
) -> Vec<usize> {
    // create and fill counting bucket with 0
    let mut count: Vec<usize> = Vec::with_capacity(data.len());
    count.resize(data.len(), 0);

    for num in &data {
        count[num - min] = count[num - min] + 1;
    }
    let mut z: usize = 0;
    for i in min..max+1 {
        while count[i - min] > 0 {
            data[z] = i;
            z += 1;
            count[i - min] = count[i - min] - 1;
        }
    }

    data
}

fn main() {
    let arr1 = vec![1, 0, 2, 9, 3, 8, 4, 7, 5, 6];
    println!("{:?}", counting_sort(arr1, 0, 9));

    let arr2 = vec![0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    println!("{:?}", counting_sort(arr2, 0, 9));

    let arr3 = vec![10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    println!("{:?}", counting_sort(arr3, 0, 10));
}
