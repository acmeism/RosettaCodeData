let median_value img radius =
  let samples = (radius*2+1) * (radius*2+1) in
  let sample = Array.make samples (0,0,0) in
  fun x y ->
    let i = ref 0 in
    for _x = (x - radius) to (x + radius) do
      for _y = (y - radius) to (y + radius) do
        let v = get_rgb img _x _y in
        sample.(!i) <- v;
        incr i;
      done;
    done;

    Array.sort compare_as_grayscale sample;
    let mid = (samples / 2) in

    if (samples mod 2) = 1
    then sample.(mid+1)
    else (color_div (color_add sample.(mid)
                               sample.(mid+1)) 2)
