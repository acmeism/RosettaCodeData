(* BitRank is a rank data structure for bit vectors *)
module BitRank = struct
  type t = {
    mutable block: int64 array;
    mutable count: int array;
  }

  let create () = { block = [||]; count = [||] }

  (* Resize resizes the bit vector to the given length *)
  let resize br num =
    let block_size = ((num + 1) lsr 6) + 1 in
    br.block <- Array.make block_size 0L;
    br.count <- Array.make block_size 0

  (* Set sets bit at position i *)
  let set br i val_ =
    if val_ = 1 then
      let idx = i lsr 6 in
      let mask = Int64.shift_left 1L (i land 63) in
      br.block.(idx) <- Int64.logor br.block.(idx) mask

  (* popcountll counts number of 1's in a 64-bit integer *)
  let popcountll n =
    let rec count_bits n acc =
      if n = 0L then acc
      else count_bits (Int64.logand n (Int64.sub n 1L)) (acc + 1)
    in
    count_bits n 0

  (* Build builds the rank structure *)
  let build br =
    for i = 1 to Array.length br.block - 1 do
      br.count.(i) <- br.count.(i - 1) + popcountll br.block.(i - 1)
    done

  (* Rank1 counts number of 1's in [0, i) *)
  let rank1 br i =
    let idx = i lsr 6 in
    let mask = Int64.pred (Int64.shift_left 1L (i land 63)) in
    br.count.(idx) + popcountll (Int64.logand br.block.(idx) mask)

  (* Rank1FromTo counts number of 1's in [i, j) *)
  let rank1_from_to br i j = rank1 br j - rank1 br i

  (* Rank0 counts number of 0's in [0, i) *)
  let rank0 br i = i - rank1 br i

  (* Rank0FromTo counts number of 0's in [i, j) *)
  let rank0_from_to br i j = rank0 br j - rank0 br i
end

(* WaveletMatrix is a wavelet matrix data structure *)
module WaveletMatrix = struct
  type t = {
    mutable height: int;
    mutable b: BitRank.t array;
    mutable pos: int array;
  }

  (* get returns bit at position i from val *)
  let get val_ i = (val_ lsr i) land 1

  (* stablePartition is equivalent to C++ stable_partition *)
  let stable_partition arr predicate =
    let result = ref [] in
    let false_values = ref [] in

    Array.iter (fun item ->
      if predicate item then
        result := item :: !result
      else
        false_values := item :: !false_values
    ) arr;

    let result_list = List.rev !result in
    let partition_point = List.length result_list in

    let combined = result_list @ (List.rev !false_values) in

    (* Update the original array *)
    List.iteri (fun i item -> arr.(i) <- item) combined;

    partition_point

  (* Helper function to count leading zeros in an int *)
  let leading_zeros n =
    if n = 0 then 64 else
    let rec count_zeros n bit acc =
      if bit < 0 then acc
      else if n land (1 lsl bit) <> 0 then acc
      else count_zeros n (bit - 1) (acc + 1)
    in
    count_zeros n 63 0

  (* Initialize wavelet matrix *)
  let init vec sigma =
    let wm = { height = 0; b = [||]; pos = [||] } in

    (* Calculate height based on sigma value *)
    wm.height <-
      if sigma = 1 then 1
      else 64 - leading_zeros (sigma - 1);

    wm.b <- Array.init wm.height (fun _ -> BitRank.create ());
    wm.pos <- Array.make wm.height 0;

    for i = 0 to wm.height - 1 do
      BitRank.resize wm.b.(i) (Array.length vec);

      for j = 0 to Array.length vec - 1 do
        BitRank.set wm.b.(i) j (get vec.(j) (wm.height - i - 1))
      done;

      BitRank.build wm.b.(i);

      (* Use a closure to capture the current i value *)
      let current_level = i in
      wm.pos.(i) <- stable_partition vec (fun c -> get c (wm.height - current_level - 1) = 0)
    done;

    wm

  (* Create a new wavelet matrix *)
  let create vec sigma_opt =
    let sigma = match sigma_opt with
      | Some s -> s
      | None ->
          (* Find the maximum element and use that as sigma *)
          let max_val = Array.fold_left max 0 vec in
          max_val + 1
    in
    init vec sigma

  (* RankSingle counts occurrences of val in range [0, i) *)
  let rank_single wm val_ i =
    let p = ref 0 in
    let i_ref = ref i in

    for j = 0 to wm.height - 1 do
      if get val_ (wm.height - j - 1) = 1 then begin
        p := wm.pos.(j) + BitRank.rank1 wm.b.(j) !p;
        i_ref := wm.pos.(j) + BitRank.rank1 wm.b.(j) !i_ref
      end else begin
        p := BitRank.rank0 wm.b.(j) !p;
        i_ref := BitRank.rank0 wm.b.(j) !i_ref
      end
    done;

    !i_ref - !p

  (* Rank counts occurrences of val in range [l, r) *)
  let rank wm val_ l r = rank_single wm val_ r - rank_single wm val_ l

  (* Quantile returns kth smallest element in [l, r) *)
  let quantile wm k l r =
    let res = ref 0 in
    let l_ref = ref l in
    let r_ref = ref r in
    let k_ref = ref k in

    for i = 0 to wm.height - 1 do
      let j = BitRank.rank0_from_to wm.b.(i) !l_ref !r_ref in
      if j > !k_ref then begin
        l_ref := BitRank.rank0 wm.b.(i) !l_ref;
        r_ref := BitRank.rank0 wm.b.(i) !r_ref
      end else begin
        l_ref := wm.pos.(i) + BitRank.rank1 wm.b.(i) !l_ref;
        r_ref := wm.pos.(i) + BitRank.rank1 wm.b.(i) !r_ref;
        k_ref := !k_ref - j;
        res := !res lor (1 lsl (wm.height - i - 1))
      end
    done;

    !res

  (* RangeFreq counts elements in [l, r) that are in value range [a, b) *)
  let rec range_freq_recursive wm i j a b l r x =
    if i = j || r <= a || b <= l then
      0
    else if a <= l && r <= b then
      j - i
    else begin
      let mid = (l + r) lsr 1 in
      let left = range_freq_recursive wm
          (BitRank.rank0 wm.b.(x) i)
          (BitRank.rank0 wm.b.(x) j)
          a b l mid (x + 1)
      in
      let right = range_freq_recursive wm
          (wm.pos.(x) + BitRank.rank1 wm.b.(x) i)
          (wm.pos.(x) + BitRank.rank1 wm.b.(x) j)
          a b mid r (x + 1)
      in
      left + right
    end

  let range_freq wm l r a b =
    range_freq_recursive wm l r a b 0 (1 lsl wm.height) 0

  (* RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found *)
  let rec range_min_recursive wm i j a b l r x val_ =
    if i = j || r <= a || b <= l then
      -1
    else if r - l = 1 then
      val_
    else begin
      let mid = (l + r) lsr 1 in
      let res = range_min_recursive wm
          (BitRank.rank0 wm.b.(x) i)
          (BitRank.rank0 wm.b.(x) j)
          a b l mid (x + 1) val_
      in

      if res < 0 then
        range_min_recursive wm
          (wm.pos.(x) + BitRank.rank1 wm.b.(x) i)
          (wm.pos.(x) + BitRank.rank1 wm.b.(x) j)
          a b mid r (x + 1)
          (val_ + (1 lsl (wm.height - x - 1)))
      else
        res
    end

  let range_min wm l r a b =
    range_min_recursive wm l r a b 0 (1 lsl wm.height) 0 0
end

(* binary search to find index in sorted array *)
let find arr x =
  let rec binary_search left right =
    if left >= right then left
    else
      let mid = (left + right) / 2 in
      if arr.(mid) < x then
        binary_search (mid + 1) right
      else
        binary_search left mid
  in
  binary_search 0 (Array.length arr)

let () =
  let n = 5 in
  let a = [|3374; 956; 2114; 3415; 3437|] in

  let input = Array.copy a in
  let backup = Array.copy a in

  (* Sort and deduplicate the array *)
  let sorted_a = Array.copy a in
  Array.sort compare sorted_a;

  (* Deduplicate *)
  let unique_a_list = ref [] in
  for i = 0 to Array.length sorted_a - 1 do
    if i = 0 || sorted_a.(i) <> sorted_a.(i - 1) then
      unique_a_list := sorted_a.(i) :: !unique_a_list
  done;

  (* Convert List to array *)
  let unique_a = Array.of_list (List.rev !unique_a_list) in

  (* Map original values to their indices in the unique array *)
  for i = 0 to n - 1 do
    input.(i) <- find unique_a backup.(i)
  done;

  let lrk_vector = [|
    [|2; 2; 1|];
    [|3; 4; 1|];
    [|4; 5; 1|];
    [|1; 2; 2|];
    [|4; 4; 1|]
  |] in

  let wm = WaveletMatrix.create input None in

  Array.iter (fun lrk ->
    let l = lrk.(0) in
    let r = lrk.(1) in
    let k = lrk.(2) in
    let l = l - 1 in (* Convert to 0-indexed *)
    Printf.printf "%d\n" unique_a.(WaveletMatrix.quantile wm (k - 1) l r)
  ) lrk_vector
