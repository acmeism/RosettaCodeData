/// Tests if the given string slice is a palindrome (with the respect to
/// codepoints, not graphemes).
///
/// # Examples
///
/// ```
/// # use playground::palindrome::is_palindrome;
/// assert!(is_palindrome("abba"));
/// assert!(!is_palindrome("baa"));
/// ```
pub fn is_palindrome(s: &str) -> bool {
    let half = s.len();
    s.chars().take(half).eq(s.chars().rev().take(half))
}

#[cfg(test)]
mod tests {

    use super::is_palindrome;

    #[test]
    fn test_is_palindrome() {
        assert!(is_palindrome("abba"));
    }
}
