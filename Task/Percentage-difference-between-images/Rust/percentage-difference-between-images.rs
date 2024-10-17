extern crate image;

use image::{GenericImageView, Rgba};

fn diff_rgba3(rgba1 : Rgba<u8>, rgba2 : Rgba<u8>) -> i32 {
    (rgba1[0] as i32 - rgba2[0] as i32).abs()
    + (rgba1[1] as i32 - rgba2[1] as i32).abs()
    + (rgba1[2] as i32 - rgba2[2] as i32).abs()
}

fn main() {
    let img1 = image::open("Lenna100.jpg").unwrap();
    let img2 = image::open("Lenna50.jpg").unwrap();
    let mut accum = 0;
    let zipper = img1.pixels().zip(img2.pixels());
    for (pixel1, pixel2) in zipper {
        accum += diff_rgba3(pixel1.2, pixel2.2);
    }
    println!("Percent difference {}", accum as f64 * 100.0/ (255.0 * 3.0 * (img1.width() * img1.height()) as f64));
}
