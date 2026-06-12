/// An Anagram is a collection of ascii Strings sorted by each String's length, then their
/// lexicographic contents
///
/// These characteristics are designed to fit an Anagram inside a BTreeSet
struct Anagram<'a>(Box<[&'a str]>);

impl<'a> Anagram<'a> {
    fn new(mut v: Vec<&'a str>) -> Anagram<'a> {
        v.sort_by(|a, b| a.len().cmp(&b.len()).then(a.cmp(b)));

        Anagram(v.into())
    }
}

impl core::fmt::Display for Anagram<'_> {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        let joined = self.0.join(" ");

        write!(f, "{joined}")
    }
}

impl Eq for Anagram<'_> {}

impl PartialEq<Self> for Anagram<'_> {
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0
    }
}

impl PartialOrd<Self> for Anagram<'_> {
    fn partial_cmp(&self, other: &Self) -> Option<core::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

// Here's where the magic happens
impl Ord for Anagram<'_> {
    fn cmp(&self, other: &Self) -> core::cmp::Ordering {
        self.0
            .iter()
            .map(|&string| string.len())
            .cmp(other.0.iter().map(|&string| string.len()))
            .then(self.0.iter().cmp(other.0.iter()))
    }
}
