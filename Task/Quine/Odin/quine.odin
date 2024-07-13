package quine

import "core:fmt"

main :: proc() {
	q := `package quine

import "core:fmt"

main :: proc() {{
	q := %c%s%c
	fmt.printf(q, 96, q, 96)
}
`
	fmt.printf(q, 96, q, 96)
}
