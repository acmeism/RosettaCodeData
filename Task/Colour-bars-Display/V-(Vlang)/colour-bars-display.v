module main

import gg
import math

const colors = ['black', 'red', 'green', 'blue', '#ff00ff', '#00ffff', 'yellow', 'white']
	.map(gg.color_from_string(it))

fn main() {
	mut context := gg.new_context(
		width:        600
		height:       400
		window_title: 'Color bars'
		frame_fn:     frame
	)
	context.run()
}

fn frame(mut ctx gg.Context) {
	ctx.begin()
	size := ctx.window_size()
	block_width := int(math.ceil(f64(size.width) / f64(colors.len)))
	for i, color in colors {
		ctx.draw_rect_filled(i * block_width, 0, block_width, size.height, color)
	}
	ctx.end()
}
