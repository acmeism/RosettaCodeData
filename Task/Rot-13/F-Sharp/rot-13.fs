let rot13 (s : string) =
   let rot c =
       match c with
       | c when c > 64 && c < 91 -> ((c - 65 + 13) % 26) + 65
       | c when c > 96 && c < 123 -> ((c - 97 + 13) % 26) + 97
       | _ -> c
   s |> Array.of_seq
   |> Array.map(int >> rot >> char)
   |> (fun seq -> new string(seq))
