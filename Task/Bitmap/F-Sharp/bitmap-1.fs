//pure functional version ... changing a pixel color provides a new Bitmap
type Color = {red: byte; green: byte; blue: byte}
type Point = {x:uint32; y:uint32}
type Bitmap = {color: Color array; maxX: uint32; maxY: uint32}

let colorBlack = {red = (byte) 0; green = (byte) 0; blue = (byte) 0}
let emptyBitmap = {color = Array.empty; maxX = (uint32) 0; maxY = (uint32) 0}
let bitmap (width: uint32) (height: uint32) =
    match width, height with
    | 0u,0u | 0u,_ | _, 0u -> emptyBitmap
    | _,_ -> {color = Array.create ((int) (width * height)) colorBlack;
            maxX = width;
            maxY = height}
let getPixel point bitmap =
    match bitmap.color with
    | c when c |> Array.isEmpty -> None
    | c when (uint32) c.Length <= (point.y * bitmap.maxY + point.x) -> None
    | c -> Some c.[(int) (point.y * bitmap.maxY + point.x)]
let setPixel point color bitmap =
    {bitmap with color = bitmap.color |> Array.mapi (function
                | i when i = (int) (point.y * bitmap.maxY + point.x) ->
                    (fun _ -> color)
                | _ -> id)}
let fill color bitmap = {bitmap with color = bitmap.color |> Array.map (fun _ ->color)}
