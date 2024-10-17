// Chess960: regex and unicode version, create 5 valid random positions.

use rand::{seq::SliceRandom, thread_rng};
use regex::Regex;

fn vec_to_string(v: Vec<&str>) -> String {
    let mut is_string = String::new();
    for ele in v {
        is_string.push_str(ele)
    }
    is_string
}
fn is_rook_king_ok(str_to_check: Vec<&str>) -> bool {
    Regex::new(r"(.*♖.*♔.*♖.*)")
        .unwrap()
        .is_match(vec_to_string(str_to_check.clone()).as_str())
}
fn is_two_bishops_ok(str_to_check: Vec<&str>) -> bool {
    Regex::new(r"(.*♗.{0}♗.*|.*♗.{2}♗.*|.*♗.{4}♗.*|.*♗.{6}♗.*)")
        .unwrap()
        .is_match(vec_to_string(str_to_check.clone()).as_str())
}
fn create_rnd_candidate() -> [&'static str; 8] {
    let mut rng = thread_rng();
    let mut chaine = ["♖", "♘", "♗", "♔", "♕", "♗", "♘", "♖"];

    loop {
        chaine.shuffle(&mut rng);
        if is_candidate_valide(chaine) {
            break chaine;
        }
    }
}
fn is_candidate_valide(s: [&str; 8]) -> bool {
    is_rook_king_ok(s.to_vec()) && is_two_bishops_ok(s.to_vec())
}
fn main() {
    for _ in 0..5 {
        println!("{:?}", create_rnd_candidate());
    }
}
