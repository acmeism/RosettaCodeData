module BA = Bigarray
module BA1 = Bigarray.Array1

let () =
  let samples = 44100 in
  let sample_rate = 44100 in
  let amplitude = 30000. in

  let raw = BA1.create BA.int16_signed BA.c_layout samples in

  let two_pi = 6.28318 in
  let increment = 440.0 /. 44100.0 in
  let x = ref 0.0 in

  for i = 0 to samples - 1 do
    raw.{i} <- truncate (amplitude *. sin (!x *. two_pi));
    x := !x +. increment;
  done;

  let buffer = SFSoundBuffer.loadFromSamples raw 1 sample_rate in

  let snd = SFSound.create () in
  SFSound.setBuffer snd buffer;
  SFSound.setLoop snd true;
  SFSound.play snd;
  while true do
    SFTime.sleep (SFTime.of_milliseconds 100_l);
  done
