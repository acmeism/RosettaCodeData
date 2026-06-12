use std::collections::{BTreeMap, BTreeSet};
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    let fs_stream = BufReader::new(File::open("unixdict.txt").unwrap());

    // Read strings from the file, we want to accept mixed-case dictionaries,
    // but not single letters unless they are actual English words
    let words_alpha: Vec<String> = fs_stream
        .lines()
        .map(|res| res.unwrap().to_lowercase())
        .filter(|word| word.len() > 1 || ["a", "i"].contains(&word.as_str()))
        .collect();

    // Sort strings into buckets keyed by their characters, sorted
    let sort_map = words_alpha.iter().map(AsRef::as_ref).fold(
        BTreeMap::<Key, Vec<&str>>::new(),
        |mut map, word: &str| {
            let line_key = Key::new(word);

            map.entry(line_key).or_default().push(word);

            map
        },
    );

    for phrase in [
        "crate",
        "algorithm",
        "Rosetta Code",
        "Bernie Sanders",
        "dough retarder",
        "lol lmao even",
    ] {
        let (sums, phrase_lowercase) = {
            let words = phrase.split_whitespace();
            let word_count = words.clone().count();
            let characters = words.flat_map(str::chars);
            let char_count = characters.clone().count();
            let lowercase = characters.map(|c| c.to_ascii_lowercase());

            // Get a sequence of lengths to search for multi-word anagrams
            // As well as a lowercase version of the phrase without spaces
            (
                Sums::from_counts(word_count, char_count),
                lowercase.collect::<String>(),
            )
        };

        let phrase_key = Key::new(&phrase_lowercase);

        let key_filter = sort_map
            .keys()
            .filter(|key| phrase_key.checked_sub(key).is_some());

        println!("\n{phrase}:");

        for sum in sums {
            let key_length_filter = key_filter.clone().filter(|key| sum.contains(&key.len()));

            let key_size_map = key_length_filter
                .filter_map(|key| sort_map.get(key).map(|value| (key, value.as_ref())))
                .collect::<BTreeMap<&Key, &[&str]>>();

            let anagrams = find_keyed_word_group(&key_size_map, &sum, &phrase_key);

            for anagram in anagrams {
                println!("\t{anagram}");
            }
        }
    }
}

fn find_keyed_word_group<'a>(
    dict: &BTreeMap<&Key, &[&'a str]>,
    lengths: &[usize],
    phrase_key: &Key,
) -> BTreeSet<Anagram<'a>> {
    let mut current = Default::default();
    let mut results = Default::default();

    fn backtrack<'a>(
        dict: &BTreeMap<&Key, &[&'a str]>,
        lengths: &[usize],
        phrase_key: &Key,
        current: &mut Vec<&'a str>,
        results: &mut BTreeSet<Anagram<'a>>,
    ) {
        let Some((&len, rest)) = lengths.split_first() else {
            // Base case

            // The phrase at this point should be empty, because we've matched all the keys
            debug_assert_eq!(phrase_key.len(), 0);

            // The current list may already exist inside the results, just in a different order
            let anagram = Anagram::new(current.clone());

            results.insert(anagram);

            return;
        };

        // Get all keys of a recursively extracted length
        let key_range_of_len = Key::key_range_of_len(len);
        let dict_of_len = dict.range(key_range_of_len);

        for (&key, &candidates) in dict_of_len {
            // Then check which of those keys will fit inside our phrase and subtract
            if let Some(phrase_key) = phrase_key.checked_sub(key) {
                for word in candidates {
                    current.push(word);
                    backtrack(dict, rest, &phrase_key, current, results);
                    current.pop();
                }
            }
        }
    }

    backtrack(dict, lengths, phrase_key, &mut current, &mut results);

    results
}
