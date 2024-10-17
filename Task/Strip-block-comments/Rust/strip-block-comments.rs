// Strips first nest of block comments
fn _commentstripper(mut txt: String, deliml: &str, delimr: &str) -> String {
    let mut out = String::new();
    if txt.contains(deliml) {
        let mut indx = txt.find(deliml).unwrap();
        out += &txt[..indx];
        txt = txt[indx + deliml.len()..].to_string();
        txt = _commentstripper(txt, deliml, delimr);
        assert!(txt.contains(delimr), "Missing closing comment delimiter");
        indx = txt.find(delimr).unwrap();
        out += &txt[indx + delimr.len()..];
    } else {
        out = txt;
    }
    return out;
}

// Strips nests of block comments
fn commentstripper(mut txt: String, deliml: &str, delimr: &str) -> String {
    while txt.contains(deliml) {
        txt = _commentstripper(txt, deliml, delimr);
    }
    return txt.to_string();
}

fn main() {
    let deliml = "/*";
    let delimr = "*/";

    println!("\nNON-NESTED BLOCK COMMENT EXAMPLE:");
    let mut sample = r#"
/**
 * Some comments
 * longer comments here that we can parse.
 *
 * Rahoo
 */
function subroutine() {
a = /* inline comment */ b + c ;
}
/*/ <-- tricky comments */

/**
* Another comment.
*/
function something() {
}
"#
    .to_string();

    println!("{}", commentstripper(sample, deliml, delimr));

    println!("\nNESTED BLOCK COMMENT EXAMPLE:");
    sample = r#"
/**
 * Some comments
 * longer comments here that we can parse.
 *
 * Rahoo
 *//*
function subroutine() {
a = /* inline comment */ b + c ;
}
/*/ <-- tricky comments */
*/
/**
* Another comment.
*/
function something() {
}
"#
    .to_string();

    println!("{}", commentstripper(sample, deliml, delimr));
}
