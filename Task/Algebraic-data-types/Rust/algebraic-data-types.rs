#![feature(box_patterns, box_syntax)]
use self::Color::*;
use std::cmp::Ordering::*;

enum Color {R,B}

type Link<T> = Option<Box<N<T>>>;
struct N<T> {
    c: Color,
    l: Link<T>,
    val: T,
    r: Link<T>,
}


impl<T: Ord> N<T> {
    fn balance(col: Color, n1: Link<T>, z: T, n2: Link<T>) -> Link<T> {
        Some(box
             match (col,n1,n2) {
                   (B, Some(box N {c: R, l: Some(box N {c: R, l: a, val: x, r: b}), val: y, r: c}), d)
                |  (B, Some(box N {c: R, l: a, val: x, r: Some (box N {c: R, l: b, val: y, r: c})}), d)
                => N {c: R, l: Some(box N {c: B, l: a, val: x, r: b}), val: y, r: Some(box N {c: B, l: c, val: z, r: d})},
                   (B, a, Some(box N {c: R, l: Some(box N {c: R, l: b, val: y, r: c}), val: v, r: d}))
                |  (B, a, Some(box N {c: R, l: b, val: y, r: Some(box N {c: R, l: c, val: v, r: d})}))
                => N {c: R, l: Some(box N {c: B, l: a, val: z, r: b}), val: y, r: Some(box N {c: B, l: c, val: v, r: d})},
                (col, a, b) => N {c: col, l: a, val: z, r: b},
        })
    }
    fn insert(x: T, n: Link<T>) -> Link<T> {
        match n {
            None => Some(box N { c: R, l: None, val: x, r: None }),
            Some(n) =>  {
                let n = *n;
                let N {c: col, l: a, val: y, r: b} = n;
                match x.cmp(&y) {
                    Greater => Self::balance(col, a,y,Self::insert(x,b)),
                    Less    => Self::balance(col, Self::insert(x,a),y,b),
                    Equal   => Some(box N {c: col, l: a, val: y, r: b})
                }
            }
        }
    }
}
