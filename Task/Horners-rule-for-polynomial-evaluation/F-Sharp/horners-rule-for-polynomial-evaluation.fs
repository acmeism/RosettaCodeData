let horner l x =
    List.rev l |> List.fold ( fun acc c -> x*acc+c) 0

horner [-19;7;-4;6] 3
