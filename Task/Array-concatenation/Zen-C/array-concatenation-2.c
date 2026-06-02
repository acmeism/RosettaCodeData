import "std/vec.zc"

fn main() {
    let a = Vec<int>::new();
    a.push(1);
    a.push(2);
    a.push(3);

    let b = Vec<int>::new();
    b.push(4);
    b.push(5);

    let c = a + b;

    print "Concatenated array: [";
    let count = c.length();
    let i = 0;
    for val in c {
        print "{val}";
        if i < count - 1 {
            print ", ";
        }
        i += 1;
    }
    println "]";
}
