extern crate image;

use image::{ImageBuffer, Pixel, Rgb};

fn main() {
    let mut img = ImageBuffer::new(256, 256);

    for x in 0..256 {
        for y in 0..256 {
            let pixel = Rgb::from_channels(0, x as u8 ^ y as u8, 0, 0);
            img.put_pixel(x, y, pixel);
        }
    }

    let _ = img.save("output.png");
}
