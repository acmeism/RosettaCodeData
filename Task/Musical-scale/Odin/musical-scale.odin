package main

import "core:sys/windows"
import "core:fmt"
import "core:time"
import ma "vendor:miniaudio"

data_callback :: proc "c" (device: ^ma.device, output: rawptr, input: rawptr, frameCount: u32) {
	sine := (^ma.waveform)(device.pUserData)
	ma.waveform_read_pcm_frames(sine, output, u64(frameCount), nil)
}

main :: proc() {
	wave_config:   ma.waveform_config = ---
	wave:          ma.waveform        = ---
	device_config: ma.device_config   = ---
	device:        ma.device          = ---

	device_config                     = ma.device_config_init(.playback)
	device_config.dataCallback        = data_callback
	device_config.pUserData           = &wave

	if ma.device_init(nil, &device_config, &device) != .SUCCESS {
		panic("Failed to open playback device")
	}
	fmt.printfln("Playback Device: %s", device.playback.name)

	wave_config = ma.waveform_config_init(
		device.playback.playback_format,
		device.playback.channels,
		device.sampleRate,
		.triangle,
		0.2,
		0,
	)

	if ma.waveform_init(&wave_config, &wave) != .SUCCESS {
		panic("Failed to init waveform")
	}
	if ma.device_start(&device) != .SUCCESS {
		panic("Failed to start playback device")
	}

	NOTES :: [8]struct {
		name: string,
		freq: f64,
	} {
		{"C" , 261.63 },
		{"D" , 293.67 },
		{"E" , 329.63 },
		{"F" , 349.23 },
		{"G" , 392.00 },
		{"A" , 440.01 },
		{"B" , 493.89 },
		{"C'", 523.26 },
	}
	when ODIN_OS == .Windows { windows.timeBeginPeriod(1) }
	for note in NOTES {
		ma.waveform_set_frequency(&wave, note.freq)
		fmt.printf("\rPlaying %s: %fHz  ", note.name, note.freq)
		time.accurate_sleep(time.Second/2)
	}
	when ODIN_OS == .Windows { windows.timeEndPeriod(1) }

	fmt.println()
	ma.device_stop(&device)
	ma.device_uninit(&device)
}

}
