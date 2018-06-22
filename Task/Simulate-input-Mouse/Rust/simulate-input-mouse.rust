extern crate autopilot;
extern crate rand;
use rand::Rng;

// Moves the mouse in a sine wave across the screen.
const TWO_PI: f64 = std::f64::consts::PI * 2.0;
fn sine_mouse_wave() -> Result<(), autopilot::mouse::MouseError> {
    let screen_size = autopilot::screen::size();
    let scoped_height = screen_size.height / 2.0 - 10.0; // Stay in screen bounds.
    for x in 0..screen_size.width as u64 {
        let y = (scoped_height * ((TWO_PI * x as f64) / screen_size.width).sin() + scoped_height)
            .round();
        let duration: u64 = rand::thread_rng().gen_range(1, 3);
        try!(autopilot::mouse::move_to(autopilot::geometry::Point::new(
            x as f64,
            y as f64
        )));
        std::thread::sleep(std::time::Duration::from_millis(duration));
    }
    Ok(())
}

fn main() {
    sine_mouse_wave().expect("Unable to move mouse");
}
