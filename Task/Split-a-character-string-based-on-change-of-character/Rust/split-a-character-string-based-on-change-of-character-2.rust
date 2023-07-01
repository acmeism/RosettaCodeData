use itertools::Itertools;

pub fn split_text(s: &str) -> Vec<String> {
    let mut r = Vec::new();
    for (_, group) in &s.chars().into_iter().group_by(|e| *e) {
        r.push(group.map(|e| e.to_string()).join(""));
    }
    r
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_splitting_text() {
        assert_eq!(split_text("gHHH5YY++///\\"), vec!["g", "HHH", "5", "YY", "++", "///", "\\"]);
        assert!(split_text("").is_empty());
    }
}
