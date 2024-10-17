extern crate piston_window;
extern crate image;

use piston_window::*;

fn main() {
    let (width, height) = (320, 240);

    let mut window: PistonWindow =
        WindowSettings::new("Red Pixel", [width, height])
        .exit_on_esc(true).build().unwrap();

    // Since we cant manipulate pixels directly, we need to manipulate the pixels on a canvas.
    // Only issue is that sub-pixels exist (which is probably why the red pixel looks like a smear on the output image)
    let mut canvas = image::ImageBuffer::new(width, height);
    canvas.put_pixel(100, 100, image::Rgba([0xff, 0, 0, 0xff]));

    // Transform into a texture so piston can use it.
    let texture: G2dTexture = Texture::from_image(
        &mut window.factory,
        &canvas,
        &TextureSettings::new()
    ).unwrap();

    // The window event loop.
    while let Some(event) = window.next() {
        window.draw_2d(&event, |context, graphics| {
            clear([1.0; 4], graphics);
            image(&texture,
            context.transform,
            graphics);
        });
    }
}
