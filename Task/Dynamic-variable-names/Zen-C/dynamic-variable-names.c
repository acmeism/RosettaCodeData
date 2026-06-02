import "std/map.zc"
import "std/io.zc"

fn main() {
    let vars = Map<int>::new();
    println "Enter three variables:";
    for _ in 0..3 {
        print "  name  : ";
        autofree let name = readln();
        print "  value : ";
        autofree let value = readln();
        vars.put(name, atoi(value));
        println "";
    }

    println "Your variables are:";
    for v in vars {
        println "  {v.key} = {v.val}";
    }
}
