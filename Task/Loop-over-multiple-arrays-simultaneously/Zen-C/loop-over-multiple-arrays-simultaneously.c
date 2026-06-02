fn main() {
    let a1: string[3] = ["a", "b", "c"];
    let a2: string[3] = ["A", "B", "C"];
    let a3: int[3] = [1, 2, 3];
    for i in a3 {
        println "{a1[i - 1]}{a2[i - 1]}{i}";
    }
}
