package main

import "core:crypto"
import "core:flags"
import "core:fmt"
import "core:math/rand"
import "core:mem"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode"

Options :: struct {
	words:      uint `args:"pos=0" usage:"Amount of words in passphrase. Default: 5"`,
	num:        uint `args:"pos=1" usage:"Amount of passphrases to generate. Default: 1"`,
	words_file: ^os.File `args:"pos=2,file=r" usage:"Words file to use. By default will try to find words.txt in the directory of the executable, then look for /usr/share/dict/words and /usr/dict/words (on POSIX). If neither found, will error."`,
	crypto:     bool `args:"--crypto" usage:"Use crypto-secure random number generator instead of default PRNG. Slower. Default: false"`,
}

default_word_file :: proc() -> ^os.File {
	// Try to look for words.txt in the directory of the executable
	{
		@(static) buff: [10 * 1024]byte
		arena: mem.Arena
		mem.arena_init(&arena, buff[:])
		allocator := mem.arena_allocator(&arena)
		exe_dir, err := os.get_executable_directory(allocator)
		if err == nil {
			word_file_path :=
				os.join_path({exe_dir, "words.txt"}, allocator) or_else panic(
					"Error: Path to executable is too long",
				)
			word_file, err := os.open(word_file_path, {.Read})
			if err == nil do return word_file
		}
	}

	// Try to open /usr/share/dict/words or /usr/dict/words
	when ODIN_OS != .Windows {
		{
			word_file, err := os.open("/usr/share/dict/words", {.Read})
			if err == nil do return word_file
		}
		{
			word_file, err := os.open("/usr/dict/words", {.Read})
			if err == nil do return word_file

		}
	}

	return nil
}

is_alpha :: proc(s: string) -> bool {
	if len(s) == 0 do return false
	for c in s {
		if !unicode.is_letter(c) do return false
	}
	return true
}

generate_passphrase :: proc(
	words: []string,
	words_n: uint,
	allocator := context.allocator,
	tmp_allocator := context.temp_allocator,
) -> string {
	picked_words := make([dynamic]string, 0, words_n, tmp_allocator)

	for _ in 0 ..< words_n {
		word := words[rand.int_max(len(words))]
		num_buff: [2]u8
		word = strings.concatenate(
			{
				strings.to_pascal_case(word, tmp_allocator),
				strconv.write_int(num_buff[:], rand.int63_max(100), 10),
			},
			tmp_allocator,
		)
		append(&picked_words, word)
	}

	return strings.join(picked_words[:], "-", allocator)
}

main :: proc() {
	opts: Options
	flags.parse_or_exit(&opts, os.args, .Unix)

	if opts.words == 0 do opts.words = 5
	if opts.num == 0 do opts.num = 1
	if opts.words_file == nil {
		f := default_word_file()
		if f == nil {
			fmt.eprintln(
				"Error: Could not find default words file. Provide path to one with '--words-file' flag.",
			)
			os.exit(1)
		}
		opts.words_file = f
	}
	if opts.crypto {
		context.random_generator = crypto.random_generator()
	}

	words_data, err := os.read_entire_file(opts.words_file, context.allocator)
	if err != nil {
		fmt.eprintln("Error: Could not read words file.")
		os.exit(1)
	}
	os.close(opts.words_file)
	defer delete(words_data)
	words_str := string(words_data)

	estimated_capacity := max(len(words_data) / 9, 1024)
	words := make([dynamic]string, 0, estimated_capacity)
	for word in strings.split_lines_iterator(&words_str) {
		w := strings.trim_space(word)
		if is_alpha(w) do append(&words, w) // Filter out words with symbols and numbers. Not required by task, but IMO looks better.
	}
	if len(words) == 0 {
		fmt.eprintln("Error: No words found in the words file.")
		os.exit(1)
	}
	defer delete(words)

	for _ in 0 ..< opts.num {
		pass := generate_passphrase(words[:], opts.words)
		fmt.println(pass)
		delete(pass)
		free_all(context.temp_allocator)
	}
}
