open System

let LoremIpsum = "
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas varius sapien
vel purus hendrerit vehicula. Integer hendrerit viverra turpis, ac sagittis arcu
pharetra id. Sed dapibus enim non dui posuere sit amet rhoncus tellus
consectetur. Proin blandit lacus vitae nibh tincidunt cursus. Cum sociis natoque
penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam tincidunt
purus at tortor tincidunt et aliquam dui gravida. Nulla consectetur sem vel
felis vulputate et imperdiet orci pharetra. Nam vel tortor nisi. Sed eget porta
tortor. Aliquam suscipit lacus vel odio faucibus tempor. Sed ipsum est,
condimentum eget eleifend ac, ultricies non dui. Integer tempus, nunc sed
venenatis feugiat, augue orci pellentesque risus, nec pretium lacus enim eu
nibh."

let Wrap words lineWidth =
    let rec loop words currentWidth = seq {
        match (words : string list) with
        | word :: rest ->
            let (stuff, pos) =
                if currentWidth > 0 then
                    if currentWidth + word.Length < lineWidth then
                        (" ", (currentWidth + 1))
                    else
                        ("\n", 0)
                else ("", 0)
            yield stuff + word
            yield! loop rest (pos + word.Length)
        | _ -> ()
    }
    loop words 0

[<EntryPoint>]
let main argv =
    for n in [72; 80] do
        printfn "%s" (String('-', n))
        let l = Seq.toList (LoremIpsum.Split((null:char[]), StringSplitOptions.RemoveEmptyEntries))
        Wrap l n |> Seq.iter (printf "%s")
        printfn ""
    0
