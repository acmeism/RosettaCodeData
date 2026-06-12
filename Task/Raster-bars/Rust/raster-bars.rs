extern crate minifb;

use std::iter::repeat;

use minifb::{Key, Window, WindowOptions};

const WIDTH: usize = 640;
const HEIGHT: usize = 360;

struct Bar {
    color: [f32; 3],
    height: u32,
    position: f32,
    speed: f32,
}

impl Bar {

    fn draw_column(&self, column_buffer: &mut [u32]) {
        let start_row = (self.position.round() as i32).clamp(0, HEIGHT as i32) as usize;
        let end_row = (start_row + self.height as usize).clamp(0, HEIGHT);

        column_buffer[start_row..end_row].iter_mut().enumerate()
            .for_each(|(row_index, color)| {
                *color = self.row_color(row_index as i32);
            });
    }

    fn row_color(&self, y: i32) -> u32 {
        let yy = y as f32 / (self.height - 1) as f32;
        let yy = 1.0 - 2.0 * (yy - 0.5).abs();

        let r = (25.0 + yy.powf((2.0 - 2.0 * self.color[0]).exp()) * 230.0).round() as u8;
        let g = (25.0 + yy.powf((2.0 - 2.0 * self.color[1]).exp()) * 230.0).round() as u8;
        let b = (25.0 + yy.powf((2.0 - 2.0 * self.color[2]).exp()) * 230.0).round() as u8;

        u32::from_be_bytes([255, r, g, b])
    }

    fn update_position(&mut self) {
        self.position += self.speed;

        if let Some(position) = self.bounce_position() {
            self.position = position;
            self.speed = -self.speed;
        }
    }

    fn bounce_position(&self) -> Option<f32> {
        if self.speed > 0.0 {
            let limit = (HEIGHT as i32 - self.height as i32) as f32;
            (self.position >= limit).then(|| limit - (self.position - limit))
        } else {
            (self.position <= 0.0).then(|| -self.position)
        }
    }

}

fn main() {

    let mut window = Window::new(
        "Raster Bars",
        WIDTH,
        HEIGHT,
        WindowOptions::default(),
    )
    .unwrap_or_else(|e| {
        panic!("{}", e);
    });

    // Limit to max ~60 fps update rate
    window.limit_update_rate(Some(std::time::Duration::from_micros(16600)));

    let mut bars = Vec::new();

    bars.push(Bar { color: [1.0, 1.0, 0.0], height: 20, position: 0.0, speed: 3.1 });
    bars.push(Bar { color: [1.0, 0.0, 0.0], height: 25, position: 0.0, speed: 0.2 });
    bars.push(Bar { color: [0.0, 1.0, 0.0], height: 7, position: 0.0, speed: 0.4 });
    bars.push(Bar { color: [0.0, 0.0, 1.0], height: 30, position: 0.0, speed: 1.0 });

    while window.is_open() && !window.is_key_down(Key::Escape) {

        let mut column_buffer = vec![0x_00_00_00_u32; HEIGHT];
        for bar in &mut bars {
            bar.draw_column(&mut column_buffer);
            bar.update_position();
        }

        let buffer: Vec<u32> = column_buffer.iter()
            .flat_map(|&row_color| repeat(row_color).take(WIDTH))
            .collect();

        window
            .update_with_buffer(&buffer, WIDTH, HEIGHT)
            .unwrap();
    }
}
