// Append numbers at same position in strings. Nigel Galloway: December 29th., 2021
let rec fG n g l=seq{match n,g,l with (n::x,g::y,l::z)->yield int((string n)+(string g)+(string l)); yield! fG x y z |_->()}
fG [1;2;3;4;5;6;7;8;9] [10;11;12;13;14;15;16;17;18] [19;20;21;22;23;24;25;26;27] |> Seq.iter(printf "%d "); printfn ""
