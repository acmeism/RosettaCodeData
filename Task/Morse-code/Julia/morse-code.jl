using PortAudio

const pstream = PortAudioStream(0, 2)
sendmorsesound(t, f) = write(pstream, SinSource(eltype(stream), samplerate(stream)*0.8, [f]), (t/1000)s)

char2morse = Dict[
      "!" => "---.", "\"" => ".-..-.", "$" => "...-..-", "'" => ".----.",
      "(" => "-.--.", ")" => "-.--.-", "+" => ".-.-.", "," => "--..--",
      "-" => "-....-", "." => ".-.-.-", "/" => "-..-.", "0" => "-----",
      "1" => ".----", "2" => "..---", "3" => "...--", "4" => "....-", "5" => ".....",
      "6" => "-....", "7" => "--...", "8" => "---..", "9" => "----.", ":" => "---...",
      ";" => "-.-.-.", "=" => "-...-", "?" => "..--..", "@" => ".--.-.", "A" => ".-",
      "B" => "-...", "C" => "-.-.", "D" => "-..", "E" => ".", "F" => "..-.",
      "G" => "--.", "H" => "....", "I" => "..", "J" => ".---", "K" => "-.-",
      "L" => ".-..", "M" => "--", "N" => "-.", "O" => "---", "P" => ".--.",
      "Q" => "--.-", "R" => ".-.", "S" => "...", "T" => "-", "U" => "..-",
      "V" => "...-", "W" => ".--", "X" => "-..-", "Y" => "-.--", "Z" => "--..",
      "[" => "-.--.", "]" => "-.--.-", "_" => "..--.-"]

function sendmorsesound(freq, duration)
cpause() = sleep(0.080)
wpause = sleep(0.400)

dit() = sendmorsesound(0.070, 700)
dash() = sensmorsesound(0.210, 700)
sendmorsechar(c) = for d in char2morse(c) d == '.' ? dit(): dash() end end
sendmorseword(w) = for c in w sendmorsechar(c) cpause() end wpause() end
sendmorse(msg) = for word in uppercase(msg) sendmorseword(word) end

sendmorse("sos sos sos")
sendmorse("The case of letters in Morse coding is ignored."
