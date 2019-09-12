#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub struct Rgb {
    pub r: u8,
    pub g: u8,
    pub b: u8,
}

impl Rgb {
    pub fn new(r: u8, g: u8, b: u8) -> Self {
        Rgb { r, g, b }
    }

    pub const BLACK: Rgb = Rgb { r: 0, g: 0, b: 0 };
    pub const RED: Rgb = Rgb { r: 255, g: 0, b: 0 };
    pub const GREEN: Rgb = Rgb { r: 0, g: 255, b: 0 };
    pub const BLUE: Rgb = Rgb { r: 0, g: 0, b: 255 };
}

#[derive(Clone, Debug)]
pub struct Image {
    width: usize,
    height: usize,
    pixels: Vec<Rgb>,
}

impl Image {
    pub fn new(width: usize, height: usize) -> Self {
        Image {
            width,
            height,
            pixels: vec![Rgb::BLACK; width * height],
        }
    }

    pub fn width(&self) -> usize {
        self.width
    }

    pub fn height(&self) -> usize {
        self.height
    }

    pub fn fill(&mut self, color: Rgb) {
        for pixel in &mut self.pixels {
            *pixel = color;
        }
    }

    pub fn get(&self, row: usize, col: usize) -> Option<&Rgb> {
        if row >= self.width {
            return None;
        }
        self.pixels.get(row * self.width + col)
    }

    pub fn get_mut(&mut self, row: usize, col: usize) -> Option<&mut Rgb> {
        if row >= self.width {
            return None;
        }
        self.pixels.get_mut(row * self.width + col)
    }
}

fn main() {
    let mut image = Image::new(16, 9);
    assert_eq!(Some(&Rgb::BLACK), image.get(3, 4));
    assert!(image.get(22, 3).is_none());

    image.fill(Rgb::RED);
    assert_eq!(Some(&Rgb::RED), image.get(3, 4));

    if let Some(pixel) = image.get_mut(3, 4) {
        *pixel = Rgb::GREEN;
    }
    assert_eq!(Some(&Rgb::GREEN), image.get(3, 4));

    if let Some(pixel) = image.get_mut(3, 4) {
        pixel.g -= 100;
        pixel.b = 20;
    }
    assert_eq!(Some(&Rgb::new(0, 155, 20)), image.get(3, 4));
}
