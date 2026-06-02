import "std/map.zc"
import "std/vec.zc"

struct A {
    age : int;
    name: string;
}

struct B {
    character: string;
    nemesis  : string;
}

fn main() {
    let tableA = [
        A{age: 27, name: "Jonah"}, A{age: 18, name: "Alan"},
        A{age: 28, name: "Glory"}, A{age: 18, name: "Popeye"},
        A{age: 28, name: "Alan"}
    ];

    let tableB = [
        B{character: "Jonah", nemesis: "Whales"},
        B{character: "Jonah", nemesis: "Spiders"},
        B{character: "Alan",  nemesis: "Ghosts"},
        B{character: "Alan",  nemesis: "Zombies"},
        B{character: "Glory", nemesis: "Buffy"}
    ];

    let h = Map<int>::new();
    let vv = Vec<Vec<int>>::new();
    for i in 0..tableA.len {
        let a = tableA[i];
        if h.contains(a.name) {
            let ix = h[a.name].unwrap();
            vv.get_ref(ix).push(i);
        } else {
            let v = Vec<int>::new();
            v.push(i);
            h.put(a.name, (int)vv.length());
            vv.push(v);
        }
    }

    println "Age  Name   Character Nemesis";
    println "---  -----  --------- -------";

    for i in 0..tableB.len {
        let b = tableB[i];
        if h.contains(b.character) {
            let ix = h[b.character].unwrap();
            let f = "%3d  %-5s  %-9s %s\n";
            for e in vv[ix] {
                let t = tableA[e];
                printf(f, t.age, t.name, b.character, b.nemesis);
            }
        }
    }

    for v in vv { v.free(); }
}
