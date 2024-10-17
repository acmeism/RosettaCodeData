use std::default::Default;
use std::ops::AddAssign;

use itertools::Itertools;
use reqwest::get;

#[derive(Default, Debug)]
struct Feature<T> {
    pub cie: T,
    pub xie: T,
    pub cei: T,
    pub xei: T,
}

impl AddAssign<Feature<bool>> for Feature<u64> {
    fn add_assign(&mut self, rhs: Feature<bool>) {
        self.cei += rhs.cei as u64;
        self.xei += rhs.xei as u64;
        self.cie += rhs.cie as u64;
        self.xie += rhs.xie as u64;
    }
}

fn check_feature(word: &str) -> Feature<bool> {
    let mut feature: Feature<bool> = Default::default();

    for window in word.chars().tuple_windows::<(char, char, char)>() {
        match window {
            ('c', 'e', 'i') => { feature.cei = true }
            ('c', 'i', 'e') => { feature.cie = true }
            (not_c, 'e', 'i') if not_c != 'c' => (feature.xei = true),
            (not_c, 'i', 'e') if not_c != 'c' => (feature.xie = true),
            _ => {}
        }
    }

    feature
}


fn maybe_is_feature_plausible(feature_count: u64, opposing_count: u64) -> Option<bool> {
    if feature_count > 2 * opposing_count { Some(true) } else if opposing_count > 2 * feature_count { Some(false) } else { None }
}

fn print_feature_plausibility(feature_plausibility: Option<bool>, feature_name: &str) {
    let plausible_msg =
        match feature_plausibility {
            None => " is implausible",
            Some(true) => "is plausible",
            Some(false) => "is definitely implausible",
        };

    println!("{} {}", feature_name, plausible_msg)
}

fn main() {
    let mut res = get(" http://wiki.puzzlers.org/pub/wordlists/unixdict.txt").unwrap();
    let texts = res.text().unwrap();

    let mut feature_count: Feature<u64> = Default::default();
    for word in texts.lines() {
        let feature = check_feature(word);
        feature_count += feature;
    }

    println!("Counting {:#?}", feature_count);

    let xie_plausibility =
        maybe_is_feature_plausible(feature_count.xie, feature_count.cie);
    let cei_plausibility =
        maybe_is_feature_plausible(feature_count.cei, feature_count.xei);

    print_feature_plausibility(xie_plausibility, "I before E when not preceded by C");
    print_feature_plausibility(cei_plausibility, "E before I when preceded by C");
    println!("The rule in general is {}",
             if xie_plausibility.unwrap_or(false) && cei_plausibility.unwrap_or(false)
             { "Plausible" } else { "Implausible" }
    );
}
