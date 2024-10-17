/* add to file Cargo.toml:
[dependencies]
winsafe = "0.0.8" # IMHO: before the appearance of winsafe="0.1" it is not worth raising the version here
rand = "0.8"
derive-new = "0.5"
*/

#![windows_subsystem = "windows"]

use derive_new::new;
use rand::{thread_rng, Rng};
use std::{cell::RefCell, rc::Rc};
use winsafe::{co, gui, prelude::*, COLORREF, HBRUSH, HPEN, RECT, SIZE};

const STEP: i32 = 3; // px, motion per frame
const GCW: i32 = 7; // game grid cell width in STEPs
const SNAKE_W: i32 = 20; // px
const FW: i32 = 20; // the width of the square field in the cells of the game grid
const TW: i32 = (FW + 2) * GCW; // total field width (with overlap for collisions) in STEPs
const ID0: i32 = FW / 2 * GCW; // starting position id

#[rustfmt::skip]
#[derive(new)]
struct Context {
                               wnd: gui::WindowMain,
    #[new(default)           ] snake: Vec<i32>, // [rect_ids] where rect_id = y * TW + x (where x, y: nSTEPs)
    #[new(value = "[ID0; 6]")] r: [i32; 6], // ID 6 rect to color in next frame (bg, tail, turn, body, food, head)
    #[new(default)           ] incr: i32, // 0 | -1 | 1 | -TW | TW - increment r[head] in next STEP
    #[new(value = "TW")      ] next_incr: i32, // `incr` in the next grid cell
    #[new(default)           ] gap: i32, // interval in STEPs to the next grid cell; negative - tail clipping mark
}

pub fn main() {
    let [bg, tail, turn, body, food, head] = [0_usize, 1, 2, 3, 4, 5];
    let grid: Vec<_> = (1..=FW).flat_map(|y| (1..=FW).map(move |x| (y * TW + x) * GCW)).collect();
    let mut colors = [(0x00, 0xF0, 0xA0); 6]; // color tail, turn, body
    colors[bg] = (0x00, 0x50, 0x90);
    colors[food] = (0xFF, 0x50, 0x00);
    colors[head] = (0xFF, 0xFF, 0x00);
    let brushes = COLORREF::new_array(&colors).map(|c| HBRUSH::CreateSolidBrush(c).unwrap());

    let wnd = gui::WindowMain::new(gui::WindowMainOpts {
        title: "Snake - Start: Space, then press W-A-S-D".to_string(),
        size: SIZE::new(FW * GCW * STEP, FW * GCW * STEP),
        class_bg_brush: brushes[bg],
        ..Default::default()
    });
    // WindowMain is based on Arc, so wnd.clone() is a shallow copy of a reference.
    let context = Rc::new(RefCell::new(Context::new(wnd.clone())));

    wnd.on().wm_paint({
        let context = Rc::clone(&context);
        move || {
            let ctx = context.borrow();
            let mut ps = winsafe::PAINTSTRUCT::default();
            let hdc = ctx.wnd.hwnd().BeginPaint(&mut ps)?;
            hdc.SelectObjectPen(HPEN::CreatePen(co::PS::NULL, 0, COLORREF::new(0, 0, 0))?)?;
            for (&id, &brush) in ctx.r.iter().zip(&brushes[bg..=head]) {
                let [left, top] = [id % TW, id / TW].map(|i| i * STEP - (STEP * GCW + SNAKE_W) / 2);
                let rect = RECT { left, top, right: left + SNAKE_W, bottom: top + SNAKE_W };
                hdc.SelectObjectBrush(brush)?;
                hdc.RoundRect(rect, SIZE::new(SNAKE_W / 2, SNAKE_W / 2))?;
            }
            Ok(ctx.wnd.hwnd().EndPaint(&ps))
        }
    });

    wnd.on().wm_key_down({
        let context = Rc::clone(&context);
        move |key| {
            let mut ctx = context.borrow_mut();
            Ok(match (ctx.incr.abs(), key.char_code as u8) {
                (0, b' ') => _ = ctx.wnd.hwnd().SetTimer(1, 10, None)?, // Start / Restart
                (TW, bt @ (b'A' | b'D')) => ctx.next_incr = if bt == b'A' { -1 } else { 1 },
                (1, bt @ (b'S' | b'W')) => ctx.next_incr = if bt == b'S' { TW } else { -TW },
                _ => (),
            })
        }
    });

    wnd.on().wm_timer(1, move || {
        let mut ctx = context.borrow_mut();
        let new_h = ctx.r[head] + ctx.incr;
        (ctx.r[body], ctx.r[head]) = (ctx.r[head], new_h);
        if ctx.gap < 0 {
            ctx.r[bg] = ctx.snake.remove(0);
            ctx.r[tail] = ctx.snake[0];
            ctx.r[turn] = ctx.snake[GCW as usize / 2];
        }
        ctx.gap -= ctx.gap.signum();
        if ctx.gap == 0 {
            ctx.gap = if new_h == ctx.r[food] { GCW } else { -GCW };
            let mut snake_cells: Vec<_> = ctx.snake.iter().step_by(GCW as usize).collect();
            if new_h == ctx.r[food] {
                ctx.wnd.hwnd().SetWindowText(&format!("Snake - Eaten: {}", snake_cells.len()))?;
                snake_cells.sort();
                ctx.r[food] = *(grid.iter())
                    .filter(|i| **i != new_h && snake_cells.binary_search(i).is_err())
                    .nth(thread_rng().gen_range(0..(grid.len() - 1 - snake_cells.len()).max(1)))
                    .unwrap_or(&0);
            } else if grid.binary_search(&new_h).is_err() || snake_cells.contains(&&new_h) {
                ctx.wnd.hwnd().KillTimer(1)?; // Stop
                let title = ctx.wnd.hwnd().GetWindowText()?;
                ctx.wnd.hwnd().SetWindowText(&(title + ". Restart: Space"))?;
                *ctx = Context::new(ctx.wnd.clone());
                return Ok(());
            }
            ctx.incr = ctx.next_incr;
        }
        ctx.snake.push(new_h);
        ctx.wnd.hwnd().InvalidateRect(None, new_h == ID0)?; // call .wm_paint(), with erase on Restart
        Ok(())
    });

    wnd.run_main(None).unwrap();
}
