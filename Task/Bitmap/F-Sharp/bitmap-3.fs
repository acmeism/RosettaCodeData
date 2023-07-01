bitmap 14u 14u
|> fill {red = (byte) 200; green = (byte) 0; blue = (byte) 10}
|> setPixel {x=5u;y=10u} {red = (byte) 0; green = (byte) 0; blue = (byte) 0}
|> getPixel {x=5u;y=10u}
|> printfn "%A"
