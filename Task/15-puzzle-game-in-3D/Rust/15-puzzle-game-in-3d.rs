// [dependencies]
// raylib = { version = "5.5" }
// rand = "0.8.0"

use raylib::prelude::*;
use rand::prelude::*;
use std::f32::consts::PI;
use std::str::FromStr;

struct Game {
    screen_width: i32,
    screen_height: i32,
    radius: i32,
    font_size: i32,
    angle: f32,
    incr: f32,
    blank: usize,
    moves: i32,
    game_over: bool,
    centers: [Vector2; 16],
    cubes: [usize; 16],
    palette: [Color; 16],
}

impl Game {
    fn new() -> Self {
        let screen_width = 960;
        let screen_height = 840;
        let radius = screen_height / 14;
        let font_size = 2 * radius / 5;
        let angle = PI / 6.0;
        let incr = 2.0 * angle;

        let palette = [
            Color::BLUE,
            Color::GREEN,
            Color::RED,
            Color::SKYBLUE,
            Color::MAGENTA,
            Color::GRAY,
            Color::LIME,
            Color::PURPLE,
            Color::VIOLET,
            Color::PINK,
            Color::GOLD,
            Color::ORANGE,
            Color::MAROON,
            Color::BEIGE,
            Color::BROWN,
            Color::RAYWHITE,
        ];

        let mut cubes = [0; 16];
        for i in 0..16 {
            cubes[i] = i;
        }

        let centers = [Vector2::zero(); 16];

        Game {
            screen_width,
            screen_height,
            radius,
            font_size,
            angle,
            incr,
            blank: 15,
            moves: 0,
            game_over: false,
            centers,
            cubes,
            palette,
        }
    }

    fn init_centers(&mut self) {
        let x = self.screen_width as f32 / 10.0;
        let y = self.radius as f32;

        for i in 0..4 {
            let cx = 2.0 * x * (i as f32 + 1.0);
            for j in 0..4 {
                let cy = (x + y) * (j as f32 + 1.0);
                self.centers[j * 4 + i] = Vector2::new(cx, cy);
            }
        }
    }

    fn draw_cube(&self, n: usize, pos: usize, d: &mut RaylibDrawHandle) {
        let r = self.radius as f32;
        let center = self.centers[pos];

        d.draw_poly(center, 6, r, 0.0, self.palette[n]);

        let cx = center.x;
        let cy = center.y;

        for i in [1, 3, 5] {
            let fi = i as f32;
            let vx = (r * (self.angle + fi * self.incr).cos() + cx) as i32;
            let vy = (r * (self.angle + fi * self.incr).sin() + cy) as i32;
            d.draw_line(cx as i32, cy as i32, vx, vy, Color::BLACK);
        }

        let ns = if n < 15 || self.game_over {
            (n + 1).to_string()
        } else {
            String::new()
        };

        let hr = r / 2.0;
        let er = r / 8.0;
        let tqr = 0.75 * r;

        d.draw_text(&ns, (cx + hr - er) as i32, cy as i32, self.font_size, Color::RAYWHITE);
        d.draw_text(&ns, (cx - hr - er) as i32, cy as i32, self.font_size, Color::RAYWHITE);
        d.draw_text(&ns, (cx - er) as i32, (cy - tqr) as i32, self.font_size, Color::RAYWHITE);
    }

    fn update_game(&mut self, rl: &RaylibHandle) {
        if self.game_over {
            return;
        }

        if rl.is_key_pressed(KeyboardKey::KEY_LEFT) {
            if self.blank % 4 != 0 {
                self.cubes.swap(self.blank, self.blank - 1);
                self.blank -= 1;
                self.moves += 1;
            }
        } else if rl.is_key_pressed(KeyboardKey::KEY_RIGHT) {
            if (self.blank + 1) % 4 != 0 {
                self.cubes.swap(self.blank, self.blank + 1);
                self.blank += 1;
                self.moves += 1;
            }
        } else if rl.is_key_pressed(KeyboardKey::KEY_UP) {
            if self.blank > 3 {
                self.cubes.swap(self.blank, self.blank - 4);
                self.blank -= 4;
                self.moves += 1;
            }
        } else if rl.is_key_pressed(KeyboardKey::KEY_DOWN) {
            if self.blank < 12 {
                self.cubes.swap(self.blank, self.blank + 4);
                self.blank += 4;
                self.moves += 1;
            }
        }
    }

    fn completed(&mut self) -> bool {
        for i in 0..16 {
            if self.cubes[i] != i {
                return false;
            }
        }
        self.palette[15] = Color::DARKGREEN;
        self.game_over = true;
        true
    }
}

fn main() {
    let mut rng = rand::thread_rng();
    let mut game = Game::new();

    // Shuffle first 15 elements (leave the blank in place)
    let mut indices: Vec<usize> = (0..15).collect();
    indices.shuffle(&mut rng);
    for i in 0..15 {
        game.cubes[i] = indices[i];
    }

    let (mut rl, thread) = raylib::init()
        .size(game.screen_width, game.screen_height)
        .title("15-puzzle game using 3D cubes")
        .build();

    rl.set_target_fps(60);
    game.init_centers();

    while !rl.window_should_close() {
        game.update_game(&rl);

        let mut d = rl.begin_drawing(&thread);
        d.clear_background(Color::BLACK);

        for i in 0..16 {
            game.draw_cube(game.cubes[i], i, &mut d);
        }

        let x = game.screen_width as f32 / 10.0;
        let y = game.radius as f32;

        if !game.completed() {
            let msg = format!("Moves = {}", game.moves);
            d.draw_text(&msg, (4.0 * x) as i32, (13.0 * y) as i32, game.font_size, Color::RAYWHITE);
        } else {
            let msg = format!("You've completed the puzzle in {} moves!", game.moves);
            d.draw_text(&msg, (3.0 * x) as i32, (13.0 * y) as i32, game.font_size, Color::RAYWHITE);
        }
    }
}
