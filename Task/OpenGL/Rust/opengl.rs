use glow::*;
use glutin::event::*;
use glutin::event_loop::{ControlFlow, EventLoop};
use std::os::raw::c_uint;

const VERTEX: &str = "#version 410
const vec2 verts[3] = vec2[3](
    vec2(0.5f, 1.0f),
    vec2(0.0f, 0.0f),
    vec2(1.0f, 0.0f)
);
out vec2 vert;
void main() {
    vert = verts[gl_VertexID];
    gl_Position = vec4(vert - 0.5, 0.0, 1.0);
}";

const FRAGMENT: &str = "#version 410
precision mediump float;
in vec2 vert;
out vec4 color;
void main() {
    color = vec4(vert, 0.5, 1.0);
}";

unsafe fn create_program(gl: &Context, vert: &str, frag: &str) -> c_uint {
    let program = gl.create_program().expect("Cannot create program");
    let shader_sources = [(glow::VERTEX_SHADER, vert), (glow::FRAGMENT_SHADER, frag)];

    let mut shaders = Vec::new();
    for (shader_type, shader_source) in shader_sources.iter() {
        let shader = gl
            .create_shader(*shader_type)
            .expect("Cannot create shader");
        gl.shader_source(shader, shader_source);
        gl.compile_shader(shader);
        if !gl.get_shader_compile_status(shader) {
            panic!(gl.get_shader_info_log(shader));
        }
        gl.attach_shader(program, shader);
        shaders.push(shader);
    }

    gl.link_program(program);
    if !gl.get_program_link_status(program) {
        panic!(gl.get_program_info_log(program));
    }

    for shader in shaders {
        gl.detach_shader(program, shader);
        gl.delete_shader(shader);
    }
    program
}

fn main() {
    let (gl, event_loop, window) = unsafe {
        let el = EventLoop::new();
        let wb = glutin::window::WindowBuilder::new()
            .with_title("Hello triangle!")
            .with_inner_size(glutin::dpi::LogicalSize::new(1024.0, 768.0));
        let windowed_context = glutin::ContextBuilder::new()
            .with_vsync(true)
            .build_windowed(wb, &el)
            .unwrap();
        let windowed_context = windowed_context.make_current().unwrap();
        let context = glow::Context::from_loader_function(|s| {
            windowed_context.get_proc_address(s) as *const _
        });
        (context, el, windowed_context)
    };

    let (program, vab) = unsafe {
        let vertex_array = gl
            .create_vertex_array()
            .expect("Cannot create vertex array");
        gl.bind_vertex_array(Some(vertex_array));

        let program = create_program(&gl, VERTEX, FRAGMENT);
        gl.use_program(Some(program));

        (program, vertex_array)
    };

    event_loop.run(move |ev, _, flow| match ev {
        Event::WindowEvent {
            event: WindowEvent::CloseRequested, ..
        } => {
            unsafe {
                gl.delete_program(program);
                gl.delete_vertex_array(vab);
            }
            *flow = ControlFlow::Exit;
        }
        Event::WindowEvent {
            event: WindowEvent::Resized(size), ..
        } => {
            unsafe {
                gl.viewport(0, 0, size.width as i32, size.height as i32);
            }
            window.resize(size);
        }
        Event::RedrawRequested(_) => unsafe {
            gl.clear_color(0.1, 0.2, 0.3, 1.0);
            gl.clear(glow::COLOR_BUFFER_BIT);
            gl.draw_arrays(glow::TRIANGLES, 0, 3);
            window.swap_buffers().unwrap();
        },
        _ => {}
    });
}
