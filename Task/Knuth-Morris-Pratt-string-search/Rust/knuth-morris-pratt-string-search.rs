use std::fmt::Display;

// Generic function to print vector elements (similar to C++ version)
// Takes a slice `&[T]` for more flexibility
fn print_vector<T: Display>(vec: &[T]) {
    print!("[");
    for (i, item) in vec.iter().enumerate() {
        print!("{}", item);
        if i < vec.len() - 1 {
            print!(", ");
        }
    }
    println!("]");
}

// Constructs the Longest Proper Prefix Suffix (LPS) array
// Takes a string slice `&str`
// Returns a `Vec<usize>`
fn construct_lps(pattern: &str) -> Vec<usize> {
    let pattern_len = pattern.len();
    if pattern_len == 0 {
        return Vec::new();
    }
    // Initialize LPS array with zeros
    let mut lps = vec![0; pattern_len];
    let mut length = 0; // Length of the previous longest prefix suffix
    let mut pattern_index = 1;
    let pattern_bytes = pattern.as_bytes(); // Work with bytes for efficient comparison

    // lps[0] is always 0, so we start from index 1
    while pattern_index < pattern_len {
        if pattern_bytes[pattern_index] == pattern_bytes[length] {
            length += 1;
            lps[pattern_index] = length;
            pattern_index += 1;
        } else {
            // This is tricky. Consider the example.
            // AAACAAAA and i = 7. The idea is similar
            // to search step
            if length != 0 {
                length = lps[length - 1];
                // Also, note that we do not increment pattern_index here
            } else {
                lps[pattern_index] = 0;
                pattern_index += 1;
            }
        }
    }
    lps
}

// KMP search algorithm
// Takes pattern and text string slices `&str`
// Returns a `Vec<usize>` containing 0-based start indices of matches
fn kmp_search(pattern: &str, text: &str) -> Vec<usize> {
    let mut result = Vec::new();
    let pattern_len = pattern.len();
    let text_len = text.len();

    if pattern_len == 0 || text_len == 0 || pattern_len > text_len {
        return result; // No matches possible
    }

    let lps = construct_lps(pattern);
    let pattern_bytes = pattern.as_bytes();
    let text_bytes = text.as_bytes();

    let mut text_index: usize = 0; // index for text
    let mut pattern_index: usize = 0; // index for pattern

    while text_index < text_len {
        if pattern_bytes[pattern_index] == text_bytes[text_index] {
            pattern_index += 1;
            text_index += 1;

            if pattern_index == pattern_len {
                // Match found, record start index
                result.push(text_index - pattern_index);
                // Move pattern_index back using LPS array to find next potential match
                pattern_index = lps[pattern_index - 1];
            }
        } else {
            // Mismatch after pattern_index matches
            if pattern_index != 0 {
                // Don't match lps[0..lps[pattern_index-1]] characters,
                // they will match anyway
                pattern_index = lps[pattern_index - 1];
            } else {
                // pattern_index is 0, just move to the next character in text
                text_index += 1;
            }
        }
    }

    result
}

fn main() {
    let texts = vec![
        "GCTAGCTCTACGAGTCTA",
        "GGCTATAATGCGTA",
        "there would have been a time for such a word",
        "needle need noodle needle",
        "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
        "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
    ];

    let patterns = vec!["TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa"];

    for (i, text) in texts.iter().enumerate() {
        println!("Text{} = {}", i + 1, text);
    }
    println!(); // Equivalent to std::cout << std::endl;

    for (i, pattern) in patterns.iter().enumerate() {
        // Translate the text index logic: j = ( i < 5 ) ? i : i - 1;
        let text_index = if i < 5 { i } else { i - 1 };
        // Ensure text_index is valid before accessing texts
        if text_index < texts.len() {
             let result = kmp_search(pattern, texts[text_index]);
             print!("Found '{}' in 'Text{}' at indices ", pattern, text_index + 1);
             print_vector(&result); // Pass result as a slice
        } else {
            println!("Warning: Calculated text index {} is out of bounds for pattern '{}'", text_index, pattern);
        }

    }
}
