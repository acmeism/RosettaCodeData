import sys
import ctypes
import math
import time
import struct
import sdl2
import sdl2.sdlmixer as mixer


def create_sound(frequency, duration):
    """Create a buffer with sound at given frequency and duration"""
    num_samples = int(48000 * duration)
    wave = struct.pack(
        f"<{num_samples}i",
        *[
            int(2**30 * math.sin(2 * math.pi * frequency / 48000 * t))
            for t in range(num_samples)
        ]
    )
    length = num_samples * 4
    sound_buffer = (ctypes.c_ubyte * length).from_buffer_copy(wave)
    sound = mixer.Mix_QuickLoad_RAW(
        ctypes.cast(sound_buffer, ctypes.POINTER(ctypes.c_ubyte)), length
    )
    return sound


def main():
    """Play sine wave"""
    mixer.Mix_Init(0)

    mixer.Mix_OpenAudioDevice(48000, sdl2.AUDIO_S32, 1, 2048, None, 0)

    note = 261.63
    semitone = math.pow(2, 1 / 12)
    duration = 0.5  # seconds

    for step in [0, 2, 2, 1, 2, 2, 2, 1]:
        note *= semitone**step
        sound = create_sound(note, duration)
        mixer.Mix_PlayChannel(0, sound, 1)
        time.sleep(duration)

    return 0


if __name__ == "__main__":
    sys.exit(main())
