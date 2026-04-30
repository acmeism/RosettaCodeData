package main

import "base:runtime"
import "core:fmt"
import "core:io"
import "core:os"
import str "core:strings"
import "core:unicode"

Value :: union {
	string,
	bool,
	[]string,
}

iterate_config_fields :: proc(src: ^string) -> (key: string, value: Value, ok: bool) {
	@(thread_local)
	array_buffer: [64]string

	for line in str.split_lines_iterator(src) {
		line := str.trim_space(line)

		// Skip empty and comment lines
		if len(line) == 0 do continue
		if line[0] == '#' || line[0] == ';' do continue

		sep := str.index_any(line, " =")

		// Boolean flag (no separator found)
		if sep == -1 {return line, true, true}

		key = str.trim_right_space(line[:sep])
		value_str := str.trim_space(line[sep + 1:])
		if value_str[0] == '=' {value_str = str.trim_left_space(value_str[1:])} 	// Handles spaces between key and '='

		counter := 0
		for el in str.split_iterator(&value_str, ",") {
			if counter >= 64 {panic("Too many elements in array")}
			array_buffer[counter] = str.trim_space(el)
			counter += 1
		}

		if counter == 1 {value = array_buffer[0]} else {value = array_buffer[:counter]}

		return key, value, true
	}
	return "", "", false
}

Config :: struct {
	full_name:       string,
	favourite_fruit: string,
	needs_peeling:   bool,
	seeds_removed:   bool,
	other_family:    []string,
	_allocator:      runtime.Allocator `fmt:"-"`,
}

Parcing_Error :: union {
	runtime.Allocator_Error,
	io.Error,
}

parse_config :: proc(
	src: string,
	allocator := context.allocator,
) -> (
	c: Config,
	err: Parcing_Error,
) {
	to_restore := context.allocator
	src := src
	c._allocator = allocator
	context.allocator = allocator
	defer context.allocator = to_restore

	key_to_lower :: proc(s: string) -> (res: string, err: io.Error) {
		assert(len(s) <= 512, "Key too long")
		@(thread_local)
		buffer: [512]byte

		b := str.builder_from_slice(buffer[:])

		for r in s {
			str.write_rune(&b, unicode.to_lower(r)) or_return
		}
		return str.to_string(b), err
	}

	for key, value in iterate_config_fields(&src) {
		key := key_to_lower(key) or_return
		switch key {
		case "fullname":
			c.full_name = str.clone(value.(string)) or_return
		case "favouritefruit":
			c.favourite_fruit = str.clone(value.(string)) or_return
		case "needspeeling":
			c.needs_peeling = value.(bool)
		case "seedsremoved":
			c.seeds_removed = value.(bool)
		case "otherfamily":
			v := value.([]string)
			c.other_family = make([]string, len(v)) or_return
			for s, i in v {c.other_family[i] = str.clone(s) or_return}
		}
	}

	return
}


free_config :: proc(c: ^Config) -> runtime.Allocator_Error {
	to_restore := context.allocator
	context.allocator = c._allocator
	defer context.allocator = to_restore

	delete(c.favourite_fruit) or_return
	delete(c.full_name) or_return
	for fm in c.other_family {
		delete(fm) or_return
	}
	delete(c.other_family) or_return
	return nil
}

main :: proc() {
	cfg_raw := os.read_entire_file("test.conf") or_else panic("Can't open file")
	cfg, err := parse_config(string(cfg_raw))
	delete(cfg_raw)
	if err != nil {
		fmt.eprintf("Parse error: %v\n", err)
		return
	}

	fmt.printfln("%#v", cfg)
}
