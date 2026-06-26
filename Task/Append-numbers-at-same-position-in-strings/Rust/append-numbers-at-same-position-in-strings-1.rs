pub fn main() {
    let list1 = 1..10;
    let list2 = 10..19;
    let list3 = 19..28;

    for (i, (j, k)) in core::iter::zip(list1, core::iter::zip(list2, list3)) {
        print!("{i}{j}{k} ");
    }
}
