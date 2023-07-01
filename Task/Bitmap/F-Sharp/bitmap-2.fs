//setups
//==check pixel for color function
let check bitmap color (x,y) =
    match (getPixel {x=x;y=y} bitmap) with
    | Some(v) -> v = color
    | _ -> false
let allPixels i j = [for x in [0u..(i-1u)] do for y in [0u..(j-1u)] -> (x,y)]

//create new empty bitmap
let myBitmap = bitmap 0u 0u
printfn "Is empty: %b" (myBitmap = emptyBitmap)
let myBitmap2 = bitmap 1u 0u
printfn "Is empty: %b" (myBitmap2 = emptyBitmap)
let myBitmap3 = bitmap 0u 1u
printfn "Is empty: %b" (myBitmap3 = emptyBitmap)
//create normal bitmap
let myBitmap4 = bitmap 14u 14u
printfn "Is not empty: %b" (not (myBitmap4 = emptyBitmap))
//just check one color
printfn "Is 1,1 black: %b" (check myBitmap4 colorBlack (1u,1u))
//check out of range color
printfn "Is 100,100 nothing: %b" (not(check myBitmap4 colorBlack (100u,100u)))
//make sure all pixels are black
printfn "Is all black: %b" ((allPixels 14u 14u) |> List.forall (check myBitmap4 colorBlack))
//fill bitmap color
let colorWhite = {red = (byte) 255; green = (byte) 255; blue = (byte) 255}
let myBitmap5 = myBitmap4 |> fill colorWhite
printfn "Is all white: %b" ((allPixels 14u 14u) |> List.forall (check myBitmap5 colorWhite))
//change just one pixel
let myBitmap6 = myBitmap5 |> setPixel {x=5u;y=10u} colorBlack
printfn "Is 5,10 black: %b" (check myBitmap4 colorBlack (5u,10u))
