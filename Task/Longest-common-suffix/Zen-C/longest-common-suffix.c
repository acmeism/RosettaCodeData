fn substring(s: char*, ss: char*, index: int, len: usize){
    strncpy(ss, s + index, len);
    ss[len] = '\0';
}

fn ends_with(s1: char*, s2: char*) -> bool {
    let l1 = strlen(s1);
    let l2 = strlen(s2);
    if l2 > l1 { return false; }
    for i in 0..l2 {
        if s1[l1 - i - 1] != s2[l2 - i - 1] { return false; }
    }
    return true;
}

fn lcs(a: string*, res: char*, len: const int) {
    res[0] = '\0';
    if len == 0 { return; }
    let sl0 = strlen(a[0]);
    if len == 1 {
        strcpy(res, a[0]);
        res[sl0] = '\0';
        return;
    }
    let min_len = sl0;
    for i in 1..len {
        let sl = strlen(a[i]);
        if sl < min_len { min_len = sl; }
    }
    if min_len == 0 { return; }

    let suffix: char[20];
    for i in 1..=min_len {
        substring(a[0], suffix, sl0 - i, i);
        for j in 1..len {
            if !ends_with(a[j], suffix) { return; }
        }
        strcpy(res, suffix);
        res[strlen(suffix)] = '\0';
    }
}

fn main() {
    let t1: string[3] = ["baabababc","baabc","bbbabc"];
    let t2: string[3] = ["baabababc","baabc","bbbazc"];
    let t3: string[7] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    let t4: string[3] = ["longest", "common", "suffix"];
    let t5: string[1] = ["suffix"];
    let t6: string[1] = [""];

    let tests: string*[6] = [t1, t2, t3, t4, t5, t6];
    let lens: int[6] = [3, 3, 7, 3, 1, 1];
    let res: char[20];
    def BS2 = "\x08\x08";
    for i in 0..6 {
        print "[";
        for j in 0..lens[i] { print "{tests[i][j]}, " };
        print "{BS2}] -> ";
        lcs(tests[i], res, lens[i]);
        println "\"{res}\"";
    }
}
