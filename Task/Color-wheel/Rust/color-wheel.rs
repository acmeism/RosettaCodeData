// [dependencies]
// image = "0.23"

use image::error::ImageResult;
use image::{Rgb, RgbImage};

fn hsv_to_rgb(h: f64, s: f64, v: f64) -> Rgb<u8> {
    let hp = h / 60.0;
    let c = s * v;
    let x = c * (1.0 - (hp % 2.0 - 1.0).abs());
    let m = v - c;
    let mut r = 0.0;
    let mut g = 0.0;
    let mut b = 0.0;
    if hp <= 1.0 {
        r = c;
        g = x;
    } else if hp <= 2.0 {
        r = x;
        g = c;
    } else if hp <= 3.0 {
        g = c;
        b = x;
    } else if hp <= 4.0 {
        g = x;
        b = c;
    } else if hp <= 5.0 {
        r = x;
        b = c;
    } else {
        r = c;
        b = x;
    }
    r += m;
    g += m;
    b += m;
    Rgb([(r * 255.0) as u8, (g * 255.0) as u8, (b * 255.0) as u8])
}

fn write_color_wheel(filename: &str, width: u32, height: u32) -> ImageResult<()> {
    let mut image = RgbImage::new(width, height);
    let margin = 10;
    let diameter = std::cmp::min(width, height) - 2 * margin;
    let xoffset = (width - diameter) / 2;
    let yoffset = (height - diameter) / 2;
    let radius = diameter as f64 / 2.0;
    for x in 0..=diameter {
        let rx = x as f64 - radius;
        for y in 0..=diameter {
            let ry = y as f64 - radius;
            let r = ry.hypot(rx) / radius;
            if r > 1.0 {
                continue;
            }
            let a = 180.0 + ry.atan2(-rx).to_degrees();
            image.put_pixel(x + xoffset, y + yoffset, hsv_to_rgb(a, r, 1.0));
        }
    }
    image.save(filename)
}

fn main() {
    match write_color_wheel("color_wheel.png", 400, 400) {
        Ok(()) => {}
        Err(error) => eprintln!("{}", error),
    }
}
