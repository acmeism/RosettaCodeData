// Reusing the 'times' procedure defined above
fn main() {
    let count = 0;
    times(fn[&]() {
        count++;
        println "Iteration {count}";
    }, 5);
}
