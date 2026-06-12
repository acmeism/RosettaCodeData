module main

import time
import os
import miniaudio

fn main() {
    cls := "\033[2J\033[0;0H" // ANSI escape code to clear screen and home cursor
    mut name, mut audio_file := "", ""
    mut number := 0

    for number < 1 && name.len < 1 == true {
       number = os.input_opt("Enter number of seconds delay > 0: ") or {panic(err)}.int()
       name = os.input_opt("Enter name of .mp3 file to play (without extension): ") or {panic(err)}.str()
    }
    print(cls)
    audio_file = "./" + "${name}" + ".mp3"  // directory of where audio file located
    println("Alarm will sound in ${number} seconds...")
	time.sleep(number * time.second)
    play_sound(audio_file)
    print(cls)
    exit(0)
}

fn play_sound(file string) {
 	engine := &miniaudio.Engine{}
	result := miniaudio.engine_init(miniaudio.null, engine)

    if result != .success {panic("Failed to initialize audio engine.")}
 	if miniaudio.engine_play_sound(engine, file.str, miniaudio.null) != .success {panic("No '${file}'.")}
    time.sleep(1000 * time.millisecond) // necessary delay
 	miniaudio.engine_uninit(engine)
}
