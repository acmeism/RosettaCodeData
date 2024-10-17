  module Slice = CCArray_slice

  let quicksort : int Array.t -> unit = fun arr ->
    let rec quicksort' : int Slice.t -> unit = fun slice ->
      let len = Slice.length slice in

      if len > 1 then begin
        let pivot = Slice.get slice (len / 2)
        and i = ref 0
        and j = ref (len - 1)
        in
        while !i < !j do
          while Slice.get slice !i < pivot do incr i done;
          while Slice.get slice !j > pivot do decr j done;

          if !i < !j then begin
            let i_val = Slice.get slice !i in
            Slice.set slice !i (Slice.get slice !j);
            Slice.set slice !j i_val;

            incr i;
            decr j;
          end
        done;

        quicksort' (Slice.sub slice 0 !i);
        quicksort' (Slice.sub slice !i (len - !i));
      end
    in
    (* Take the array into an aliased array slice *)
    Slice.full arr |> quicksort'
