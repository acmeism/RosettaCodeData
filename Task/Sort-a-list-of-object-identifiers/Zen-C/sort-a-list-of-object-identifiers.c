import "std/string.zc"

fn string_comparer(a: const void*, b: const void*) -> int {
    return strcmp(*(char**)a, *(char**)b);
}

fn main() {
    let oids: char*[6] = [
        "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
        "1.3.6.1.4.1.11.2.17.5.2.0.79",
        "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
        "1.3.6.1.4.1.11150.3.4.0.1",
        "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
        "1.3.6.1.4.1.11150.3.4.0"
    ];
    let oids2: char*[6];
    for i in 0..6 {
        let s = String::from(oids[i]);
        let sections = s.split('.');
        let len = sections.length();
        let sb = String::new("");
        for j in 0..len {
            let ps = sections[j].pad_left(5, ' ');
            sb.append(&ps);
            if j < len - 1 { sb.push_rune('.'); }
            sections[j].free();
        }
        let len2 = sb.length();
        let buf = (char*)malloc(sizeof(char) * (len2 + 1));
        strcpy(buf, sb.c_str());
        oids2[i] = buf;
     }
     qsort(oids2, 6, sizeof(char*), string_comparer);
     for i in 0..6 {
         let s = String::from(oids2[i]);
         let t = s.replace(" ", "");
         println "{t}";
         free(oids2[i]);
     }
}
