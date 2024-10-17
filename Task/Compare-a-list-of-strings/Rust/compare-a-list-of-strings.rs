fn strings_are_equal(seq: &[&str]) -> bool {
    match seq {
        &[] | &[_] => true,
        &[x, y, ref tail @ ..] if x == y => strings_are_equal(&[&[y], tail].concat()),
        _ => false
    }
}

fn asc_strings(seq: &[&str]) -> bool {
    match seq {
        &[] | &[_] => true,
        &[x, y, ref tail @ ..] if x < y => asc_strings(&[&[y], tail].concat()),
        _ => false
    }
}
