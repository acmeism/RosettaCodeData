use pixels::{Pixels, SurfaceTexture};
use winit::event::*;
use winit::event_loop::{ControlFlow, EventLoop};
use winit::window::WindowBuilder;
use std::{env, fs};

mod wireworld;
use wireworld::{State, WireWorld};

const EMPTY_COLOR: [u8; 3] = [0x00, 0x00, 0x00];
const WIRE_COLOR: [u8; 3] =  [0xFC, 0xF9, 0xF8];
const HEAD_COLOR: [u8; 3] =  [0xFC, 0x00, 0x00];
const TAIL_COLOR: [u8; 3] =  [0xFC, 0x99, 0x33];

fn main() {
    let args: Vec<_> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Error: No Input File");
        std::process::exit(1);
    }

    let input_file = fs::read_to_string(&args[1]).unwrap();
    let mut world: WireWorld = input_file.parse().unwrap();

    let event_loop = EventLoop::new();
    let window = WindowBuilder::new()
        .with_title(format!("Wireworld - {}", args[1]))
        .build(&event_loop).unwrap();
    let size = window.inner_size();
    let texture = SurfaceTexture::new(size.width, size.height, &window);
    let mut image_buffer = Pixels::new(world.width as u32, world.height as u32, texture).unwrap();

    event_loop.run(move |ev, _, flow| {
        match ev {
            Event::WindowEvent {
                event: WindowEvent::CloseRequested, ..
            } => {
                *flow = ControlFlow::Exit;
            }
            Event::WindowEvent {
                event: WindowEvent::KeyboardInput {
                    input: KeyboardInput {
                        state: ElementState::Pressed,
                        virtual_keycode: Some(VirtualKeyCode::Space),
                        ..
                    }, ..
                }, ..
            } => {
                world.next();
                window.request_redraw();
            }
            Event::RedrawRequested(_) => {
                let frame = image_buffer.get_frame();
                for (pixel, state) in frame.chunks_exact_mut(4).zip(world.data.iter()) {
                    let color = match state {
                        State::Empty => EMPTY_COLOR,
                        State::Conductor => WIRE_COLOR,
                        State::ElectronTail => TAIL_COLOR,
                        State::ElectronHead => HEAD_COLOR,
                    };

                    pixel[0] = color[0]; // R
                    pixel[1] = color[1]; // G
                    pixel[2] = color[2]; // B
                    pixel[3] = 0xFF;     // A
                }
                image_buffer.render().unwrap();
            }
            _ => {}
        }
    });
}
