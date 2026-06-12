/// A Key is an ascii String sorted by its length, then lexicographic contents
///
/// It supports operations that help with using it as a key in B-Tree containers
struct Key(String);

impl Key {
    fn new(s: &str) -> Key {
        let mut b = s.to_string().into_bytes();
        b.sort();

        Key(String::from_utf8(b).unwrap())
    }

    /// Since keys are sorted by length first, return range of keys from given length
    fn key_range_of_len(len: usize) -> core::ops::RangeInclusive<Key> {
        let lower = Key("\0".repeat(len));
        let upper = Key("~".repeat(len));

        lower..=upper
    }

    fn len(&self) -> usize {
        self.0.len()
    }

    /// Check if `self` is a superset of `other`. If so, return their difference
    fn checked_sub(&self, other: &Self) -> Option<Self> {
        let mut ascii_count = [0u8; 128];

        // Build a frequency map from our key
        for &b in self.0.as_bytes() {
            ascii_count[b as usize] += 1;
        }

        // Any character in `other` that's not in `self` will cause our frequency map to overflow
        for &b in other.0.as_bytes() {
            ascii_count[b as usize] = ascii_count[b as usize].checked_sub(1)?;
        }

        // Create new key from the remaining frequency map
        let result = ascii_count
            .iter()
            .enumerate()
            .flat_map(|(ascii, &count)| core::iter::repeat_n(ascii as u8 as char, count as usize))
            .collect();

        Some(Key(result))
    }
}

impl Eq for Key {}

impl PartialEq<Self> for Key {
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0
    }
}

impl PartialOrd<Self> for Key {
    fn partial_cmp(&self, other: &Self) -> Option<core::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

// Here's where the magic happens
impl Ord for Key {
    fn cmp(&self, other: &Self) -> core::cmp::Ordering {
        self.len().cmp(&other.len()).then(self.0.cmp(&other.0))
    }
}
