extern crate image;
use image::{DynamicImage, GenericImageView, ImageBuffer, Rgba};

/// index of the alpha channel in RGBA
const ALPHA: usize = 3;

/// Computes the luminance of a single pixel
/// Result lies within `u16::MIN..u16::MAX`
const fn luminance(rgba: Rgba<u8>) -> u16 {
    let Rgba([r, g, b, _a]) = rgba;
    55 * r as u16 + 183 * g as u16 + 19 * b as u16
}

/// computes the median of a given histogram
/// Result lies within `u16::MIN..u16::MAX`
fn get_median(total: usize, histogram: &[usize]) -> u16 {
    let mut sum = 0;
    for (index, &count) in histogram.iter().enumerate() {
        sum += count;
        if sum >= total / 2 {
            return index as u16;
        }
    }

    u16::MAX
}

/// computes the histogram of a given image
fn compute_histogram(img: &DynamicImage) -> Vec<usize> {
    let mut histogram = vec![0; 1 << u16::BITS];

    img.pixels()
        .map(|(_x, _y, pixel)| luminance(pixel))
        .for_each(|luminance| histogram[luminance as usize] += 1);

    histogram
}

/// returns a black or white pixel with an alpha value
const fn black_white(is_white: bool, alpha: u8) -> [u8; 4] {
    if is_white {
        [255, 255, 255, alpha]
    } else {
        [0, 0, 0, alpha]
    }
}

/// create a monochome compy of the given image
/// preserves alpha data
fn convert_to_monochrome(img: &DynamicImage) -> ImageBuffer<Rgba<u8>, Vec<u8>> {
    let histogram = compute_histogram(img);

    let (width, height) = img.dimensions();
    let pixel_count = (width * height) as usize;
    let median = get_median(pixel_count, &histogram);

    let pixel_buffer = img.pixels()
        .flat_map(|(_x, _y, pixel)| black_white(luminance(pixel) > median, pixel[ALPHA]))
        .collect();

    ImageBuffer::from_vec(width, height, pixel_buffer).unwrap_or_else(|| unreachable!())
}

fn main() {
    let img = image::open("lena.jpg").expect("could not load image file");
    let img = convert_to_monochrome(&img);
    img.save("lena-mono.png").expect("could not save result image");
}
