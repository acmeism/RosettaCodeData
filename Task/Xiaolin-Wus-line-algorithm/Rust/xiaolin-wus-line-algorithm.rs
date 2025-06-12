use std::cmp;

fn wu_draw_line(
    mut x0: f32,
    mut y0: f32,
    mut x1: f32,
    mut y1: f32,
    mut plot: impl FnMut(i32, i32, f32),
) {
    let ipart = |x: f32| -> i32 { x.floor() as i32 };
    let round = |x: f32| -> f32 { x.round() };
    let fpart = |x: f32| -> f32 { x - x.floor() };
    let rfpart = |x: f32| -> f32 { 1.0 - fpart(x) };

    let steep = (y1 - y0).abs() > (x1 - x0).abs();
    if steep {
        std::mem::swap(&mut x0, &mut y0);
        std::mem::swap(&mut x1, &mut y1);
    }
    if x0 > x1 {
        std::mem::swap(&mut x0, &mut x1);
        std::mem::swap(&mut y0, &mut y1);
    }

    let dx = x1 - x0;
    let dy = y1 - y0;
    let gradient = if dx == 0.0 { 1.0 } else { dy / dx };

    let xpx11: i32;
    let mut intery: f32;
    {
        let xend = round(x0);
        let yend = y0 + gradient * (xend - x0);
        let xgap = rfpart(x0 + 0.5);
        xpx11 = xend as i32;
        let ypx11 = ipart(yend);
        if steep {
            plot(ypx11, xpx11, rfpart(yend) * xgap);
            plot(ypx11 + 1, xpx11, fpart(yend) * xgap);
        } else {
            plot(xpx11, ypx11, rfpart(yend) * xgap);
            plot(xpx11, ypx11 + 1, fpart(yend) * xgap);
        }
        intery = yend + gradient;
    }

    let xpx12: i32;
    {
        let xend = round(x1);
        let yend = y1 + gradient * (xend - x1);
        let xgap = rfpart(x1 + 0.5);
        xpx12 = xend as i32;
        let ypx12 = ipart(yend);
        if steep {
            plot(ypx12, xpx12, rfpart(yend) * xgap);
            plot(ypx12 + 1, xpx12, fpart(yend) * xgap);
        } else {
            plot(xpx12, ypx12, rfpart(yend) * xgap);
            plot(xpx12, ypx12 + 1, fpart(yend) * xgap);
        }
    }

    if steep {
        for x in xpx11 + 1..xpx12 {
            let ipy = ipart(intery);
            plot(ipy, x, rfpart(intery));
            plot(ipy + 1, x, fpart(intery));
            intery += gradient;
        }
    } else {
        for x in xpx11 + 1..xpx12 {
            let ipy = ipart(intery);
            plot(x, ipy, rfpart(intery));
            plot(x, ipy + 1, fpart(intery));
            intery += gradient;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_wu_draw_line() {
        let mut pixels = vec![vec![0.0; 10]; 10]; // Create a 10x10 grid of floats
        let plot = |x: i32, y: i32, brightness: f32| {
            if x >= 0 && x < 10 && y >= 0 && y < 10 {
                pixels[x as usize][y as usize] = brightness;
            }
        };

        wu_draw_line(1.0, 1.0, 8.0, 8.0, plot);

        // Basic validation: Check that some pixels are lit up
        assert!(pixels[1][1] > 0.0);
        assert!(pixels[8][8] > 0.0);

        // You can add more specific assertions here based on the expected output.
        // For example, check the values of pixels along the expected line path.
        // Be aware of floating point precision when comparing.
    }

    #[test]
    fn test_wu_draw_line_steep() {
        let mut pixels = vec![vec![0.0; 10]; 10]; // Create a 10x10 grid of floats
        let plot = |x: i32, y: i32, brightness: f32| {
            if x >= 0 && x < 10 && y >= 0 && y < 10 {
                pixels[x as usize][y as usize] = brightness;
            }
        };

        wu_draw_line(1.0, 1.0, 2.0, 8.0, plot);

        // Basic validation: Check that some pixels are lit up
        assert!(pixels[1][1] > 0.0);
        assert!(pixels[2][8] > 0.0);
    }
}
</syntaxhighlight >
