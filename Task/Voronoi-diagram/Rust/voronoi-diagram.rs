extern crate piston;
extern crate opengl_graphics;
extern crate graphics;
extern crate touch_visualizer;

#[cfg(feature = "include_sdl2")]
extern crate sdl2_window;

extern crate getopts;
extern crate voronoi;
extern crate rand;

use touch_visualizer::TouchVisualizer;
use opengl_graphics::{ GlGraphics, OpenGL };
use graphics::{ Context, Graphics };
use piston::window::{ Window, WindowSettings };
use piston::input::*;
use piston::event_loop::*;
#[cfg(feature = "include_sdl2")]
use sdl2_window::Sdl2Window as AppWindow;
use voronoi::{voronoi, Point, make_polygons};
use rand::Rng;

static DEFAULT_WINDOW_HEIGHT: u32 = 600;
static DEFAULT_WINDOW_WIDTH:  u32 = 600;

struct Settings {
    lines_only: bool,
    random_count: usize
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mut opts = getopts::Options::new();
    opts.optflag("l", "lines_only", "Don't color polygons, just outline them");
    opts.optopt("r", "random_count", "On keypress \"R\", put this many random points on-screen", "RANDOMCOUNT");
    let matches = opts.parse(&args[1..]).expect("Failed to parse args");

    let settings = Settings{
        lines_only: matches.opt_present("l"),
        random_count: match matches.opt_str("r") {
            None => { 50 },
            Some(s) => { s.parse().expect("Random count of bad format") }
        }
    };

    event_loop(&settings);

}

fn random_point() -> [f64; 2] {
    [rand::thread_rng().gen_range(0., DEFAULT_WINDOW_HEIGHT as f64), rand::thread_rng().gen_range(0., DEFAULT_WINDOW_WIDTH as f64)]
}

fn random_color() -> [f32; 4] {
    [rand::random::<f32>(), rand::random::<f32>(), rand::random::<f32>(), 1.0]
}

fn random_voronoi(dots: &mut Vec<[f64;2]>, colors: &mut Vec<[f32;4]>, num: usize) {
    dots.clear();
    colors.clear();

    for _ in 0..num {
        dots.push(random_point());
        colors.push(random_color());
    }
}

fn event_loop(settings: &Settings) {
    let opengl = OpenGL::V3_2;
    let mut window: AppWindow = WindowSettings::new("Interactive Voronoi", [DEFAULT_WINDOW_HEIGHT, DEFAULT_WINDOW_WIDTH])
        .exit_on_esc(true).opengl(opengl).build().unwrap();

    let ref mut gl = GlGraphics::new(opengl);
    let mut touch_visualizer = TouchVisualizer::new();
    let mut events = Events::new(EventSettings::new().lazy(true));
    let mut dots = Vec::new();
    let mut colors = Vec::new();

    let mut mx = 0.0;
    let mut my = 0.0;

    while let Some(e) = events.next(&mut window) {
        touch_visualizer.event(window.size(), &e);
        if let Some(button) = e.release_args() {
            match button {
                Button::Keyboard(key) => {
                    if key == piston::input::keyboard::Key::N { dots.clear(); colors.clear(); }
                    if key == piston::input::keyboard::Key::R { random_voronoi(&mut dots, &mut colors, settings.random_count); }
                }
                Button::Mouse(_) => {
                    dots.push([mx, my]);
                    colors.push(random_color());
                },
                _ => ()
            }
        };
        e.mouse_cursor(|x, y| {
            mx = x;
            my = y;
        });
        if let Some(args) = e.render_args() {
            gl.draw(args.viewport(), |c, g| {
                graphics::clear([1.0; 4], g);
                let mut vor_pts = Vec::new();
                for d in &dots {
                    vor_pts.push(Point::new(d[0], d[1]));
                }
                if vor_pts.len() > 0 {
                    let vor_diagram = voronoi(vor_pts, DEFAULT_WINDOW_WIDTH as f64);
                    let vor_polys = make_polygons(&vor_diagram);
                    for (i, poly) in vor_polys.iter().enumerate() {
                        if settings.lines_only {
                            draw_lines_in_polygon(poly, &c, g);
                        } else {
                            draw_polygon(poly, &c, g, colors[i]);
                        }
                    }
                }
                for d in &dots {
                    draw_ellipse(&d, &c, g);
                }
            });
        }
    }

}

fn draw_lines_in_polygon<G: Graphics>(
    poly: &Vec<Point>,
    c: &Context,
    g: &mut G,
)
{
    let color = [0.0, 0.0, 1.0, 1.0];

    for i in 0..poly.len()-1 {
        graphics::line(
            color,
            2.0,
            [poly[i].x.into(), poly[i].y.into(), poly[i+1].x.into(), poly[i+1].y.into()],
            c.transform,
            g
        )
    }
}

fn draw_polygon<G: Graphics>(
    poly: &Vec<Point>,
    c: &Context,
    g: &mut G,
    color: [f32; 4]
) {
    let mut polygon_points: Vec<[f64; 2]> = Vec::new();

    for p in poly {
        polygon_points.push([p.x.into(), p.y.into()]);
    }

    graphics::polygon(
        color,
        polygon_points.as_slice(),
        c.transform,
        g
    )
}

fn draw_ellipse<G: Graphics>(
    cursor: &[f64; 2],
    c: &Context,
    g: &mut G,
) {
    let color = [0.0, 0.0, 0.0, 1.0];
    graphics::ellipse(
        color,
        graphics::ellipse::circle(cursor[0], cursor[1], 4.0),
        c.transform,
        g
    );
}
