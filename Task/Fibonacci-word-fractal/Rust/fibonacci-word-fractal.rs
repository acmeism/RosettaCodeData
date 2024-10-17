// [dependencies]
// svg = "0.8.0"

use svg::node::element::path::Data;
use svg::node::element::Path;

fn fibonacci_word(n: usize) -> Vec<u8> {
    let mut f0 = vec![1];
    let mut f1 = vec![0];
    if n == 0 {
        return f0;
    } else if n == 1 {
        return f1;
    }
    let mut i = 2;
    loop {
        let mut f = Vec::with_capacity(f1.len() + f0.len());
        f.extend(&f1);
        f.extend(f0);
        if i == n {
            return f;
        }
        f0 = f1;
        f1 = f;
        i += 1;
    }
}

struct FibwordFractal {
    current_x: f64,
    current_y: f64,
    current_angle: i32,
    line_length: f64,
    max_x: f64,
    max_y: f64,
}

impl FibwordFractal {
    fn new(x: f64, y: f64, length: f64, angle: i32) -> FibwordFractal {
        FibwordFractal {
            current_x: x,
            current_y: y,
            current_angle: angle,
            line_length: length,
            max_x: 0.0,
            max_y: 0.0,
        }
    }
    fn execute(&mut self, n: usize) -> Path {
        let mut data = Data::new().move_to((self.current_x, self.current_y));
        for (i, byte) in fibonacci_word(n).iter().enumerate() {
            data = self.draw_line(data);
            if *byte == 0u8 {
                self.turn(if i % 2 == 1 { -90 } else { 90 });
            }
        }
        Path::new()
            .set("fill", "none")
            .set("stroke", "black")
            .set("stroke-width", "1")
            .set("d", data)
    }
    fn draw_line(&mut self, data: Data) -> Data {
        let theta = (self.current_angle as f64).to_radians();
        self.current_x += self.line_length * theta.cos();
        self.current_y += self.line_length * theta.sin();
        if self.current_x > self.max_x {
            self.max_x = self.current_x;
        }
        if self.current_y > self.max_y {
            self.max_y = self.current_y;
        }
        data.line_to((self.current_x, self.current_y))
    }
    fn turn(&mut self, angle: i32) {
        self.current_angle = (self.current_angle + angle) % 360;
    }
    fn save(file: &str, order: usize) -> std::io::Result<()> {
        use svg::node::element::Rectangle;
        let x = 5.0;
        let y = 5.0;
        let rect = Rectangle::new()
            .set("width", "100%")
            .set("height", "100%")
            .set("fill", "white");
        let mut ff = FibwordFractal::new(x, y, 1.0, 0);
        let path = ff.execute(order);
        let document = svg::Document::new()
            .set("width", 5 + ff.max_x as usize)
            .set("height", 5 + ff.max_y as usize)
            .add(rect)
            .add(path);
        svg::save(file, &document)
    }
}

fn main() {
    FibwordFractal::save("fibword_fractal.svg", 22).unwrap();
}
