let output: String = "as⃝df̅".chars().rev().collect();
assert_ne!(output, "f̅ds⃝a"); // should be this
assert_eq!(output, "̅fd⃝sa");
