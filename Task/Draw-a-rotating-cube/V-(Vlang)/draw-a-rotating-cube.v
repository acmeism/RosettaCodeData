import gg
import gx
import math

struct RotatingCube {
    mut:
	width    int
	height   int
	fore     gx.Color
	nodes    [][]f64
	edges    [][]int
	scale_f  f64
}

fn new_rotating_cube(width int, height int) RotatingCube {
	mut nodes := [
		[f64(-1.0), -1, -1],
		[f64(-1.0), -1,  1],
		[f64(-1.0),  1, -1],
		[f64(-1.0),  1,  1],
		[f64(1.0), -1, -1],
		[f64(1.0), -1,  1],
		[f64(1.0),  1, -1],
		[f64(1.0),  1,  1],
    ]
	mut edges := [
		[0, 1],
		[1, 3],
		[3, 2],
		[2, 0],
		[4, 5],
		[5, 7],
		[7, 6],
		[6, 4],
		[0, 4],
		[1, 5],
		[2, 6],
		[3, 7],
    ]
	mut cube := RotatingCube{
		width: width
		height: height
		fore: gx.blue
		nodes: nodes
		edges: edges
		scale_f: 100.0
	}
	cube.scale(cube.scale_f)
	cube.rotate_cube(math.pi / 4, math.sqrt(math.atan(2.0)))
	return cube
}

fn (mut rc RotatingCube) scale(s f64) {
	for i in 0 .. rc.nodes.len {
		for j in 0 .. 3 {
			rc.nodes[i][j] = rc.nodes[i][j] * s
		}
	}
}

fn (mut rc RotatingCube) rotate_cube(angle_x f64, angle_y f64) {
	sin_x := math.sin(angle_x)
	cos_x := math.cos(angle_x)
	sin_y := math.sin(angle_y)
	cos_y := math.cos(angle_y)
	for i in 0 .. rc.nodes.len {
		x := rc.nodes[i][0]
		y := rc.nodes[i][1]
		z := rc.nodes[i][2]
		rc.nodes[i][0] = x * cos_x - z * sin_x
		rc.nodes[i][2] = z * cos_x + x * sin_x
		z_new := rc.nodes[i][2]
		rc.nodes[i][1] = y * cos_y - z_new * sin_y
		rc.nodes[i][2] = z_new * cos_y + y * sin_y
	}
}

fn (mut rc RotatingCube) draw_cube(mut ctx gg.Context) {
	ctx.begin()
	cx := f32(rc.width / 2)
	cy := f32(rc.height / 2)
	for edge in rc.edges {
		n1 := rc.nodes[edge[0]]
		n2 := rc.nodes[edge[1]]
		x1 := f32(n1[0]) + cx
		y1 := f32(n1[1]) + cy
		x2 := f32(n2[0]) + cx
		y2 := f32(n2[1]) + cy
		ctx.draw_line(x1, y1, x2, y2, rc.fore)
	}
	for node in rc.nodes {
		x := f32(node[0]) + cx - 4
		y := f32(node[1]) + cy - 4
		ctx.draw_rect_filled(x, y, 8, 8, rc.fore)
	}
	ctx.end()
}

fn (mut rc RotatingCube) update() {
	rc.rotate_cube(math.pi / 180, 0)
}

fn frame(mut cube RotatingCube) {
    mut ctx := gg.Context{}
	cube.update()
	cube.draw_cube(mut ctx)
}

fn main() {
	width := 640
	height := 640
	mut cube := new_rotating_cube(width, height)
	mut context := gg.new_context(
		width: width
		height: height
		window_title: "Rotating cube"
		bg_color: gx.white
		frame_fn: frame
		user_data: &cube
	)
	context.run()
}
