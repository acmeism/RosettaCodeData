fn main() {
    let strs: [&[&[u8]]; 7] = [
        &[b"interspecies", b"interstellar", b"interstate"],
        &[b"throne", b"throne"],
        &[b"throne", b"dungeon"],
        &[b"cheese"],
        &[b""],
        &[b"prefix", b"suffix"],
        &[b"foo", b"foobar"],
    ];
    strs.iter().for_each(|list| match lcp(list) {
        Some(prefix) => println!("{}", String::from_utf8_lossy(&prefix)),
        None => println!(),
    });
}

fn lcp(list: &[&[u8]]) -> Option<Vec<u8>> {
    if list.is_empty() {
        return None;
    }
    let mut ret = Vec::new();
    let mut i = 0;
    loop {
        let mut c = None;
        for word in list {
            if i == word.len() {
                return Some(ret);
            }
            match c {
                None => {
                    c = Some(word[i]);
                }
                Some(letter) if letter != word[i] => return Some(ret),
                _ => continue,
            }
        }
        if let Some(letter) = c {
            ret.push(letter);
        }
        i += 1;
    }
}
