use num_integer::Integer;
use std::{f64, usize};

const MAXSIZE: usize = 200;

#[derive(Debug)]
struct HerionanTriangle {
    a: usize,
    b: usize,
    c: usize,
    area: usize,
    perimeter: usize,
}

fn get_area(a: &usize, b: &usize, c: &usize) -> f64 {
    let s = (a + b + c) as f64 / 2.;
    (s * (s - *a as f64) * (s - *b as f64) * (s - *c as f64)).sqrt()
}

fn is_heronian(a: &usize, b: &usize, c: &usize) -> bool {
    let area = get_area(a, b, c);
    // Heronian if the area is an integer number
    area != 0. && area.fract() == 0.
}

fn main() {
    let mut heronians: Vec<HerionanTriangle> = vec![];

    (1..=MAXSIZE).into_iter().for_each(|a| {
        (a..=MAXSIZE).into_iter().for_each(|b| {
            (b..=MAXSIZE).into_iter().for_each(|c| {
                if a + b > c && a.gcd(&b).gcd(&c) == 1 && is_heronian(&a, &b, &c) {
                    heronians.push(HerionanTriangle {
                        a,
                        b,
                        c,
                        perimeter: a + b + c,
                        area: get_area(&a, &b, &c) as usize,
                    })
                }
            })
        })
    });

    // sort by area then by perimeter, then by maximum side
    heronians.sort_unstable_by(|x, y| {
        x.area
            .cmp(&y.area)
            .then(x.perimeter.cmp(&y.perimeter))
            .then((x.a.max(x.b).max(x.c)).cmp(&y.a.max(y.b).max(y.c)))
    });

    println!(
        "Primitive Heronian triangles with sides up to 200: {}",
        heronians.len()
    );

    println!("\nFirst ten when ordered by increasing area, then perimeter,then maximum sides:");
    heronians.iter().take(10).for_each(|h| println!("{:?}", h));

    println!("\nAll with area 210 subject to the previous ordering:");
    heronians
        .iter()
        .filter(|h| h.area == 210)
        .for_each(|h| println!("{:?}", h));
}
