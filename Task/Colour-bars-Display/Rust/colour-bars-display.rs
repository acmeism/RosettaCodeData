use pixels::{Pixels, SurfaceTexture}; // 0.2.0
use winit::event::*; // 0.24.0
use winit::event_loop::{ControlFlow, EventLoop};
use winit::window::{Fullscreen, WindowBuilder};

fn main() {
    let event_loop = EventLoop::new();
    let window = WindowBuilder::new()
        .with_title("Colour Bars")
        .with_decorations(false)
        .with_fullscreen(Some(Fullscreen::Borderless(None)))
        .build(&event_loop).unwrap();
    let size = window.inner_size();
    let texture = SurfaceTexture::new(size.width, size.height, &window);
    let mut image_buffer = Pixels::new(8, 1, texture).unwrap();
    let frame = image_buffer.get_frame();
    frame.copy_from_slice(&[
        0x00, 0x00, 0x00, 0xFF, // black
        0xFF, 0x00, 0x00, 0xFF, // red
        0x00, 0xFF, 0x00, 0xFF, // green
        0x00, 0x00, 0xFF, 0xFF, // blue
        0xFF, 0x00, 0xFF, 0xFF, // magenta
        0x00, 0xFF, 0xFF, 0xFF, // cyan
        0xFF, 0xFF, 0x00, 0xFF, // yellow
        0xFF, 0xFF, 0xFF, 0xFF, // white
    ]);

    image_buffer.render().unwrap();

    event_loop.run(move |ev, _, flow| {
        match ev {
            Event::WindowEvent {
                event: WindowEvent::KeyboardInput { input, .. }, ..
            } => {
                if input.virtual_keycode == Some(VirtualKeyCode::Escape) {
                    *flow = ControlFlow::Exit;
                }
            }
            Event::RedrawRequested(_) | Event::WindowEvent {
                event: WindowEvent::Focused(true), ..
            } => {
                image_buffer.render().unwrap();
            }
            _ => {}
        }
    });
}
