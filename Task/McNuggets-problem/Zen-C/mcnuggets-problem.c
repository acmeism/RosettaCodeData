fn mcnugget(limit: int) {
    autofree let sv = (bool*)calloc(limit + 1, sizeof(bool));
    for s in 0..=limit step 6 {
        for n in s..=limit step 9 {
            for t in n..=limit step 20 { sv[t] = true; }
        }
    }
    for i in limit..=0 step -1 {
        if !sv[i] {
            println "Maximum non-McNuggets number is {i}.";
            return;
        }
    }
}

fn main() {
    mcnugget(100);
}
