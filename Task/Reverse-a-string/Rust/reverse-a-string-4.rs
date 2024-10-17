use unicode_segmentation::UnicodeSegmentation;

let output: String = "as⃝df̅".graphemes(true).rev().collect();
assert_eq!(output, "f̅ds⃝a");
