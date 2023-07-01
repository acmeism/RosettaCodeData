// using version 0.107.0 of piston_window
use piston_window::{clear, ellipse, line_from_to, PistonWindow, WindowSettings};

const PI: f64 = std::f64::consts::PI;
const WIDTH: u32 = 640;
const HEIGHT: u32 = 480;

const ANCHOR_X: f64 = WIDTH as f64 / 2. - 12.;
const ANCHOR_Y: f64 = HEIGHT as f64 / 4.;
const ANCHOR_ELLIPSE: [f64; 4] = [ANCHOR_X - 3., ANCHOR_Y - 3., 6., 6.];

const ROPE_ORIGIN: [f64; 2] = [ANCHOR_X, ANCHOR_Y];
const ROPE_LENGTH: f64 = 200.;
const ROPE_THICKNESS: f64 = 1.;

const DELTA: f64 = 0.05;
const STANDARD_GRAVITY_VALUE: f64 = -9.81;

// RGBA Colors
const BLACK: [f32; 4] = [0., 0., 0., 1.];
const RED: [f32; 4] = [1., 0., 0., 1.];
const GOLD: [f32; 4] = [216. / 255., 204. / 255., 36. / 255., 1.0];
fn main() {
    let mut window: PistonWindow = WindowSettings::new("Pendulum", [WIDTH, HEIGHT])
        .exit_on_esc(true)
        .build()
        .unwrap();

    let mut angle = PI / 2.;
    let mut angular_vel = 0.;

    while let Some(event) = window.next() {
        let (angle_sin, angle_cos) = angle.sin_cos();
        let ball_x = ANCHOR_X + angle_sin * ROPE_LENGTH;
        let ball_y = ANCHOR_Y + angle_cos * ROPE_LENGTH;

        let angle_accel = STANDARD_GRAVITY_VALUE / ROPE_LENGTH * angle_sin;
        angular_vel += angle_accel * DELTA;
        angle += angular_vel * DELTA;
        let rope_end = [ball_x, ball_y];
        let ball_ellipse = [ball_x - 7., ball_y - 7., 14., 14.];

        window.draw_2d(&event, |context, graphics, _device| {
            clear([1.0; 4], graphics);
            line_from_to(
                BLACK,
                ROPE_THICKNESS,
                ROPE_ORIGIN,
                rope_end,
                context.transform,
                graphics,
            );
            ellipse(RED, ANCHOR_ELLIPSE, context.transform, graphics);
            ellipse(GOLD, ball_ellipse, context.transform, graphics);
        });
    }
}
