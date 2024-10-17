fn longest_common_substring(s1: &str, s2: &str) -> String {
    let s1_chars: Vec<char> = s1.chars().collect();
    let s2_chars: Vec<char> = s2.chars().collect();
    let mut lcs = "".to_string();

    for i in 0..s1_chars.len() {
        for j in 0..s2_chars.len() {
            if s1_chars[i] == s2_chars[j] {
                let mut tmp_lcs = s2_chars[j].to_string();
                let mut tmp_i = i + 1;
                let mut tmp_j = j + 1;

                while tmp_i < s1_chars.len() && tmp_j < s2_chars.len() && s1_chars[tmp_i] == s2_chars[tmp_j] {
                    tmp_lcs = format!("{}{}", tmp_lcs, s1_chars[tmp_i]);
                    tmp_i += 1;
                    tmp_j += 1;
                }

                if tmp_lcs.len() > lcs.len() {
                    lcs = tmp_lcs;
                }
            }
        }
    }

    lcs
}

fn main() {
    let s1 = "thisisatest";
    let s2 = "testing123testing";
    let lcs = longest_common_substring(s1, s2);
    println!("{}", lcs);
}
