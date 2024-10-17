// [dependencies]
// image = "0.23"

use image::{GrayImage, Luma};

type Vector = [f64; 3];

fn normalize(v: &mut Vector) {
    let inv_len = 1.0/dot_product(v, v).sqrt();
    v[0] *= inv_len;
    v[1] *= inv_len;
    v[2] *= inv_len;
}

fn dot_product(v1: &Vector, v2: &Vector) -> f64 {
    v1.iter().zip(v2.iter()).map(|(x, y)| *x * *y).sum()
}

fn draw_sphere(radius: u32, k: f64, ambient: f64, dir: &Vector) -> GrayImage {
    let width = radius * 4;
    let height = radius * 3;
    let mut image = GrayImage::new(width, height);
    let mut vec = [0.0; 3];
    let diameter = radius * 2;
    let r = radius as f64;
    let xoffset = (width - diameter)/2;
    let yoffset = (height - diameter)/2;
    for i in 0..diameter {
        let x = i as f64 - r;
        for j in 0..diameter {
            let y = j as f64 - r;
            let z = r * r - x * x - y * y;
            if z >= 0.0 {
                vec[0] = x;
                vec[1] = y;
                vec[2] = z.sqrt();
                normalize(&mut vec);
                let mut s = dot_product(&dir, &vec);
                if s < 0.0 {
                    s = 0.0;
                }
                let mut lum = 255.0 * (s.powf(k) + ambient)/(1.0 + ambient);
                if lum < 0.0 {
                    lum = 0.0;
                } else if lum > 255.0 {
                    lum = 255.0;
                }
                image.put_pixel(i + xoffset, j + yoffset, Luma([lum as u8]));
            }
        }
    }
    image
}

fn main() {
    let mut dir = [-30.0, -30.0, 50.0];
    normalize(&mut dir);
    match draw_sphere(200, 1.5, 0.2, &dir).save("sphere.png") {
        Ok(()) => {}
        Err(error) => eprintln!("{}", error),
    }
}
