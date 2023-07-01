extern crate image;

use image::{ImageBuffer, Pixel, Rgb};

fn main() {
    // 4 : 3 ratio is nice
    let width = 8000;
    let height = 6000;

    let mut img = ImageBuffer::new(width as u32, height as u32);

    // constants to tweak for appearance
    let cx = -0.9;
    let cy = 0.27015;
    let iterations = 110;

    for x in 0..width {
        for y in 0..height {
            let inner_height = height as f32;
            let inner_width = width as f32;
            let inner_y = y as f32;
            let inner_x = x as f32;

            let mut zx = 3.0 * (inner_x - 0.5 * inner_width) / (inner_width);
            let mut zy = 2.0 * (inner_y - 0.5 * inner_height) / (inner_height);

            let mut i = iterations;

            while zx * zx + zy * zy < 4.0 && i > 1 {
                let tmp = zx * zx - zy * zy + cx;
                zy = 2.0 * zx * zy + cy;
                zx = tmp;
                i -= 1;
            }

            // guesswork to make the rgb color values look okay
            let r = (i << 3) as u8;
            let g = (i << 5) as u8;
            let b = (i << 4) as u8;
            let pixel = Rgb::from_channels(r, g, b, 0);
            img.put_pixel(x as u32, y as u32, pixel);
        }
    }

    let _ = img.save("output.png");

}
