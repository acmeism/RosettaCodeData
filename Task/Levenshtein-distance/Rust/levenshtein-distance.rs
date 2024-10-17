fn main() {
    println!("{}", levenshtein_distance("kitten", "sitting"));
    println!("{}", levenshtein_distance("saturday", "sunday"));
    println!("{}", levenshtein_distance("rosettacode", "raisethysword"));
}

fn levenshtein_distance(word1: &str, word2: &str) -> usize {
    let w1 = word1.chars().collect::<Vec<_>>();
    let w2 = word2.chars().collect::<Vec<_>>();

    let word1_length = w1.len() + 1;
    let word2_length = w2.len() + 1;

    let mut matrix = vec![vec![0; word1_length]; word2_length];

    for i in 1..word1_length { matrix[0][i] = i; }
    for j in 1..word2_length { matrix[j][0] = j; }

    for j in 1..word2_length {
        for i in 1..word1_length {
            let x: usize = if w1[i-1] == w2[j-1] {
                matrix[j-1][i-1]
            } else {
                1 + std::cmp::min(
                        std::cmp::min(matrix[j][i-1], matrix[j-1][i])
                        , matrix[j-1][i-1])
            };
            matrix[j][i] = x;
        }
    }
    matrix[word2_length-1][word1_length-1]
}
