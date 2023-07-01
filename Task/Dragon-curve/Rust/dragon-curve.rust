use ggez::{
    conf::{WindowMode, WindowSetup},
    error::GameResult,
    event,
    graphics::{clear, draw, present, Color, MeshBuilder},
    nalgebra::Point2,
    Context,
};
use std::time::Duration;

// L-System to create the sequence needed for a Dragon Curve.
// This function creates the next generation given the current one
// L-System from https://www.cs.unm.edu/~joel/PaperFoldingFractal/L-system-rules.html
//
fn l_system_next_generation(current_generation: &str) -> String {
    let f_rule = "f-h";
    let h_rule = "f+h";
    let mut next_gen = String::new();
    for char in current_generation.chars() {
        match char {
            'f' => next_gen.push_str(f_rule),
            'h' => next_gen.push_str(h_rule),
            '-' | '+' => next_gen.push(char),
            _ => panic!("Unknown char {}", char),
        }
    }
    next_gen
}

// The rest of the code is for drawing the output and is specific to using the
// ggez 2d game library: https://ggez.rs/

const WINDOW_WIDTH: f32 = 700.0;
const WINDOW_HEIGHT: f32 = 700.0;
const START_X: f32 = WINDOW_WIDTH / 6.0;
const START_Y: f32 = WINDOW_HEIGHT / 6.0;
const MAX_DEPTH: i32 = 15;
const LINE_LENGTH: f32 = 20.0;

struct MainState {
    start_gen: String,
    next_gen: String,
    line_length: f32,
    max_depth: i32,
    current_depth: i32,
}

impl MainState {
    fn new() -> GameResult<MainState> {
        let start_gen = "f";
        let next_gen = String::new();
        let line_length = LINE_LENGTH;
        let max_depth = MAX_DEPTH;
        let current_depth = 0;
        Ok(MainState {
            start_gen: start_gen.to_string(),
            next_gen,
            line_length,
            max_depth,
            current_depth,
        })
    }
}

impl event::EventHandler for MainState {
    // In each repetition of the event loop a new generation of the L-System
    // is generated and drawn, until the maximum depth is reached.
    // Each time the line length is reduced so that the overall dragon curve
    // can be seen in the window as it spirals and gets bigger.
    // The update sleeps for 0.5 seconds just so that its pogression can be watched.
    //
    fn update(&mut self, _ctx: &mut Context) -> GameResult {
        if self.current_depth < self.max_depth {
            self.next_gen = l_system_next_generation(&self.start_gen);
            self.start_gen = self.next_gen.clone();
            self.line_length -= (self.line_length / self.max_depth as f32) * 1.9;
            self.current_depth += 1;
        }
        ggez::timer::sleep(Duration::from_millis(500));
        Ok(())
    }

    fn draw(&mut self, ctx: &mut Context) -> GameResult {
        let grey = Color::from_rgb(77, 77, 77);
        let blue = Color::from_rgb(51, 153, 255);
        let initial_point_blue = Point2::new(START_X, START_Y);
        clear(ctx, grey);
        draw_lines(
            &self.next_gen,
            ctx,
            self.line_length,
            blue,
            initial_point_blue,
        )?;
        present(ctx)?;
        Ok(())
    }
}

fn next_point(current_point: Point2<f32>, heading: f32, line_length: f32) -> Point2<f32> {
    let next_point = (
        (current_point.x + (line_length * heading.to_radians().cos().trunc() as f32)),
        (current_point.y + (line_length * heading.to_radians().sin().trunc() as f32)),
    );
    Point2::new(next_point.0, next_point.1)
}

fn draw_lines(
    instructions: &str,
    ctx: &mut Context,
    line_length: f32,
    colour: Color,
    initial_point: Point2<f32>,
) -> GameResult {
    let line_width = 2.0;
    let mut heading = 0.0;
    let turn_angle = 90.0;
    let mut start_point = initial_point;
    let mut line_builder = MeshBuilder::new();
    for char in instructions.chars() {
        let end_point = next_point(start_point, heading, line_length);
        match char {
            'f' | 'h' => {
                line_builder.line(&[start_point, end_point], line_width, colour)?;
                start_point = end_point;
            }
            '+' => heading += turn_angle,
            '-' => heading -= turn_angle,
            _ => panic!("Unknown char {}", char),
        }
    }
    let lines = line_builder.build(ctx)?;
    draw(ctx, &lines, (initial_point,))?;
    Ok(())
}

fn main() -> GameResult {
    let cb = ggez::ContextBuilder::new("dragon curve", "huw")
        .window_setup(WindowSetup::default().title("Dragon curve"))
        .window_mode(WindowMode::default().dimensions(WINDOW_WIDTH, WINDOW_HEIGHT));
    let (ctx, event_loop) = &mut cb.build()?;
    let state = &mut MainState::new()?;
    event::run(ctx, event_loop, state)
}
