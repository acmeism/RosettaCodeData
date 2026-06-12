fn manacher(input: &str) -> String {
    let s = String::from("^") + input.split("").collect::<Vec<&str>>().join("#").as_str() + "$";
    let len = s.len();
    let mut pals = vec![0_usize; len];
    let (mut center, mut right) = (0_usize, 0_usize);
    for i in 1..len - 1 {
        pals[i] = (right > i && right - i > 0 && pals[2 * center + 1 - i] > 0) as usize;
        while s.as_bytes()[i + pals[i] + 1] == s.as_bytes()[i - pals[i] - 1] {
            pals[i] += 1;
        }
        if i + pals[i] > right {
            (center, right) = (i + 1, i + pals[i]);
        }
    }
    let (centerindex, maxlen) =
        pals.iter()
            .enumerate()
            .fold((0, 0), |max, (i, v)| if v > &max.1 { (i, *v) } else { max });
    return input[(centerindex - maxlen) / 2..(centerindex + maxlen) / 2].to_string();
}

fn main() {
    for teststring in [
        "babaccd",
        "rotator",
        "reverse",
        "forever",
        "several",
        "palindrome",
        "abracadabra",
    ] {
        let pal = manacher(teststring);
        if pal.len() < 2 {
            println!(
                "No palindromes of 2 or more letters found in \"{}.\"",
                teststring
            );
        } else {
            println!(
                "The longest palindromic substring of {} is: \"{}\"",
                teststring, pal
            );
        }
    }
}
