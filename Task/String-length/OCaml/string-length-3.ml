let utf8_length (s: String.t) =
	let byte_length = String.length s in
	let rec count acc n =
		if n = byte_length
		then acc
		else
		let n' = n + (String.get_utf_8_uchar s n |> Uchar.utf_decode_length) in
		count (succ acc) n'
	in
	count 0 0
;;
