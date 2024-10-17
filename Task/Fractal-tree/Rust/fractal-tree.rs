//Cargo deps :
//  piston = "0.35.0"
//  piston2d-graphics = "0.23.0"
//  piston2d-opengl_graphics = "0.49.0"
//  pistoncore-glutin_window = "0.42.0"

extern crate piston;
extern crate graphics;
extern crate opengl_graphics;
extern crate glutin_window;

use piston::window::WindowSettings;
use piston::event_loop::{Events, EventSettings};
use piston::input::RenderEvent;
use glutin_window::GlutinWindow as Window;
use opengl_graphics::{GlGraphics, OpenGL};
use graphics::{clear, line, Context};

const ANG: f64 = 20.0;
const COLOR: [f32; 4] = [1.0, 0.0, 0.5, 1.0];
const LINE_THICKNESS: f64 = 5.0;
const DEPTH: u32 = 11;

fn main() {
    let mut window: Window = WindowSettings::new("Fractal Tree", [1024, 768])
        .opengl(OpenGL::V3_2)
        .exit_on_esc(true)
        .build()
        .unwrap();
    let mut gl = GlGraphics::new(OpenGL::V3_2);

    let mut events = Events::new(EventSettings::new());
    while let Some(e) = events.next(&mut window) {
        if let Some(args) = e.render_args() {
            gl.draw(args.viewport(), |c, g| {
                clear([1.0, 1.0, 1.0, 1.0], g);
                draw_fractal_tree(512.0, 700.0, 0.0, DEPTH, c, g);
            });
        }
    }
}

fn draw_fractal_tree(x1: f64, y1: f64, angle: f64, depth: u32, c: Context, g: &mut GlGraphics) {
    let x2 = x1 + angle.to_radians().sin() * depth as f64 * 10.0;
    let y2 = y1 - angle.to_radians().cos() * depth as f64 * 10.0;
    line(
        COLOR,
        LINE_THICKNESS * depth as f64 * 0.2,
        [x1, y1, x2, y2],
        c.transform,
        g,
    );
    if depth > 0 {
        draw_fractal_tree(x2, y2, angle - ANG, depth - 1, c, g);
        draw_fractal_tree(x2, y2, angle + ANG, depth - 1, c, g);
    }
}
