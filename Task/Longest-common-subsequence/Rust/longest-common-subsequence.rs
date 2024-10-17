use std::cmp;

fn lcs(string1: String, string2: String) -> (usize, String){
    let total_rows = string1.len() + 1;
    let total_columns = string2.len() + 1;
    // rust doesn't allow accessing string by index
    let string1_chars = string1.as_bytes();
    let string2_chars = string2.as_bytes();

    let mut table = vec![vec![0; total_columns]; total_rows];

    for row in 1..total_rows{
        for col in 1..total_columns {
            if string1_chars[row - 1] == string2_chars[col - 1]{
                table[row][col] = table[row - 1][col - 1] + 1;
            } else {
                table[row][col] = cmp::max(table[row][col-1], table[row-1][col]);
            }
        }
    }

    let mut common_seq = Vec::new();
    let mut x = total_rows - 1;
    let mut y = total_columns - 1;

    while x != 0 && y != 0 {
        // Check element above is equal
        if table[x][y] == table[x - 1][y] {
            x = x - 1;
        }
        // check element to the left is equal
        else if table[x][y] == table[x][y - 1] {
            y = y - 1;
        }
        else {
            // check the two element at the respective x,y position is same
            assert_eq!(string1_chars[x-1], string2_chars[y-1]);
            let char = string1_chars[x - 1];
            common_seq.push(char);
            x = x - 1;
            y = y - 1;
        }
    }
    common_seq.reverse();
    (table[total_rows - 1][total_columns - 1], String::from_utf8(common_seq).unwrap())
}

fn main() {
    let res = lcs("abcdaf".to_string(), "acbcf".to_string());
    assert_eq!((4 as usize, "abcf".to_string()), res);
    let res = lcs("thisisatest".to_string(), "testing123testing".to_string());
    assert_eq!((7 as usize, "tsitest".to_string()), res);
    // LCS for input Sequences “AGGTAB” and “GXTXAYB” is “GTAB” of length 4.
    let res = lcs("AGGTAB".to_string(), "GXTXAYB".to_string());
    assert_eq!((4 as usize, "GTAB".to_string()), res);
}
