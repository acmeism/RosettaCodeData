fun swapref (x, y) =
    let temp = !x in x := !y; y := temp end
