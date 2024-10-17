use winit::event::{Event, WindowEvent};  // winit 0.24
use winit::event_loop::{ControlFlow, EventLoop};
use winit::window::WindowBuilder;

fn main() {
    let event_loop = EventLoop::new();
    let _win = WindowBuilder::new()
        .with_title("Window")
        .build(&event_loop).unwrap();

    event_loop.run(move |ev, _, flow| {
        match ev {
            Event::WindowEvent {
                event: WindowEvent::CloseRequested, ..
            } => {
                *flow = ControlFlow::Exit;
            }
            _ => {}
        }
    });
}
