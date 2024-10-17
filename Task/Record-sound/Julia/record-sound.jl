using PortAudio, LibSndFile

stream = PortAudioStream("Microphone (USB Microphone)", 1, 0) # 44100 samples/sec
buf = read(stream, 441000)
save("recorded10sec.wav", buf)
