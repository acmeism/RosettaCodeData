struct Dimension {
	mut:
	width  int
	height int
}

fn (mut m Dimension) size() (int, int) {
	m.width = 20
	m.height = 30
	return m.width, m.height
}
