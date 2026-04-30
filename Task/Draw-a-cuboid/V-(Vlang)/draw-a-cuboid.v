fn cuboid(dx int, dy int, dz int) {
	println("cuboid $dx $dy $dz:")
	cub_line(dy + 1, dx, 0, "+-|")
	for i in 1 .. dy + 1 {
		cub_line(dy - i + 1, dx, i - 1, "/ |")
	}
	cub_line(0, dx, dy, "+-|")
	for _ in 0 .. (4 * dz - dy - 2) {
		cub_line(0, dx, dy, "| |")
	}
	cub_line(0, dx, dy, "| +")
	for i in 1 .. dy + 1 {
		cub_line(0, dx, dy - i, "| /")
	}
	last_line := "+-"
	print("".repeat(1) + last_line[0].ascii_str())
	println(last_line[1].ascii_str().repeat(9 * dx - 1) + last_line[0].ascii_str())
}

fn cub_line(nir int, dx int, dy int, cde string) {
	if cde.len < 3 { return }
	print(" ".repeat(nir + 1) + cde[0].ascii_str())
	print(cde[1].ascii_str().repeat(9 * dx - 1))
	print(cde[0].ascii_str())
	println(" ".repeat(dy + 1) + cde[2].ascii_str())
}

fn main() {
	cuboid(2, 3, 4)
	cuboid(1, 1, 1)
	cuboid(6, 2, 1)
}
