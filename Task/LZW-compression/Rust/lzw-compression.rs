use std::collections::HashMap;

fn compress(data: &[u8]) -> Vec<u32> {
    // Build initial dictionary.
    let mut dictionary: HashMap<Vec<u8>, u32> = (0u32..=255)
        .map(|i| (vec![i as u8], i))
        .collect();

    let mut w = Vec::new();
    let mut compressed = Vec::new();

    for &b in data {
        let mut wc = w.clone();
        wc.push(b);

        if dictionary.contains_key(&wc) {
            w = wc;
        } else {
            // Write w to output.
            compressed.push(dictionary[&w]);

            // wc is a new sequence; add it to the dictionary.
            dictionary.insert(wc, dictionary.len() as u32);
            w.clear();
            w.push(b);
        }
    }

    // Write remaining output if necessary.
    if !w.is_empty() {
        compressed.push(dictionary[&w]);
    }

    compressed
}

fn decompress(mut data: &[u32]) -> Vec<u8> {
    // Build the dictionary.
    let mut dictionary: HashMap::<u32, Vec<u8>> = (0u32..=255)
        .map(|i| (i, vec![i as u8]))
        .collect();

    let mut w = dictionary[&data[0]].clone();
    data = &data[1..];
    let mut decompressed = w.clone();

    for &k in data {
        let entry = if dictionary.contains_key(&k) {
            dictionary[&k].clone()
        } else if k == dictionary.len() as u32 {
            let mut entry = w.clone();
            entry.push(w[0]);
            entry
        } else {
            panic!("Invalid dictionary!");
        };

        decompressed.extend_from_slice(&entry);

        // New sequence; add it to the dictionary.
        w.push(entry[0]);
        dictionary.insert(dictionary.len() as u32, w);

        w = entry;
    }

    decompressed
}

fn main() {
    let compressed = compress("TOBEORNOTTOBEORTOBEORNOT".as_bytes());
    println!("{:?}", compressed);

    let decompressed = decompress(&compressed);
    let decompressed = String::from_utf8(decompressed).unwrap();
    println!("{}", decompressed);
}
