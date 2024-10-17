use std::str::FromStr;

// Precondition: range doesn't contain multibyte UTF-8 characters
fn range_expand(range : &str) -> Vec<i32> {
   range.split(',').flat_map(|item| {
        match i32::from_str(item) {
            Ok(n) => n..n+1,
            _ => {
                let dashpos=
                    match item.rfind("--") {
                        Some(p) => p,
                        None => item.rfind('-').unwrap(),
                    };
                let rstart=i32::from_str(
                    unsafe{ item.slice_unchecked(0,dashpos)} ).unwrap();
                let rend=i32::from_str(
                    unsafe{ item.slice_unchecked(dashpos+1,item.len()) } ).unwrap();
                rstart..rend+1
            },
        }
    }).collect()
}

fn main() {
    println!("{:?}", range_expand("-6,-3--1,3-5,7-11,14,15,17-20"));
}
