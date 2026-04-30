package main

import ba "core:container/bit_array"
import "core:flags"
import "core:fmt"
import "core:os"
import "core:strings"

print_row :: proc(a: ^ba.Bit_Array, alive_char, dead_char: rune) {
	it := ba.make_iterator(a)
	for c in ba.iterate_by_all(&it) {
		fmt.print(alive_char if c else dead_char, sep = "", flush = false)
	}
	fmt.println()
}

evolve :: proc(prev, next: ^ba.Bit_Array) -> (alive: bool) {
	if next.bits == nil do ba.init(next, prev.length)
	assert(prev.length == next.length)
	for i in 0 ..< next.length {
		ancestors := 0
		for j in max(0, i - 1) ..= min(prev.length, i + 1) {
			if ba.unsafe_get(prev, j) do ancestors += 1
		}
		_alive := ancestors == 2
		ba.set(next, i, _alive)
		if _alive && !alive do alive = true
	}
	return alive
}

parse_row :: proc(str: string, res: ^ba.Bit_Array, alive_char, dead_char: rune) {
	str := strings.trim_space(str)
	if res.bits == nil do ba.init(res, len(str))

	for c, i in str {
		if (c != dead_char && c != alive_char) do fmt.panicf("invalid character in seed: '%c'", c)
		ba.set(res, i, c == alive_char)
	}
}

Args :: struct {
	seed       : string `args:"pos=0,required" usage:"Initial seed string, e.g. '.###..#.#'"`    ,
	alive_char : rune   `args:"name=a" usage:"Character representing alive cells. Default: '#'"` ,
	dead_char  : rune   `args:"name=d" usage:"Character representing dead cells.  Default: '.'"` ,
	generations: uint   `args:"name=g" usage:"Number of generations to simulate.  Default: 10"`  ,
}

main :: proc() {
	args := Args {
		alive_char  = '#',
		dead_char   = '.',
		generations = 10,
	}
	flags.parse_or_exit(&args, os.args)

	row  := ba.Bit_Array{}
	next := ba.Bit_Array{}
	
	parse_row(args.seed, &row, args.alive_char, args.dead_char)

	for generation in 1 ..= args.generations {
		fmt.printf("Generation % -3d: ", generation, flush = false)
		print_row(&row, args.alive_char, args.dead_char)
		alive := evolve(&row, &next)
		if !alive {
			fmt.println("Population has died out.")
			break
		}
		row, next = next, row
	}
}
