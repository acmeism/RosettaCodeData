(* country_code : string -> int *)
(* Get the length of a valid IBAN given the two chars long country code *)
fun country_code (str : string) : int =
  case str of
    "AL" => 28 | "AD" => 24 | "AT" => 20 | "AZ" => 28
  | "BE" => 16 | "BH" => 22 | "BA" => 20 | "BR" => 29
  | "BG" => 22 | "CR" => 21 | "HR" => 21 | "CY" => 28
  | "CZ" => 24 | "DK" => 18 | "DO" => 28 | "EE" => 20
  | "FO" => 18 | "FI" => 18 | "FR" => 27 | "GE" => 22
  | "DE" => 22 | "GI" => 23 | "GR" => 27 | "GL" => 18
  | "GT" => 28 | "HU" => 28 | "IS" => 26 | "IE" => 22
  | "IL" => 23 | "IT" => 27 | "KZ" => 20 | "KW" => 30
  | "LV" => 21 | "LB" => 28 | "LI" => 21 | "LT" => 20
  | "LU" => 20 | "MK" => 19 | "MT" => 31 | "MR" => 27
  | "MU" => 30 | "MC" => 27 | "MD" => 24 | "ME" => 22
  | "NL" => 18 | "NO" => 15 | "PK" => 24 | "PS" => 29
  | "PL" => 28 | "PT" => 25 | "RO" => 24 | "SM" => 27
  | "SA" => 24 | "RS" => 22 | "SK" => 24 | "SI" => 19
  | "ES" => 24 | "SE" => 24 | "CH" => 21 | "TN" => 24
  | "TR" => 26 | "AE" => 23 | "GB" => 22 | "VG" => 24
  | _ => raise Domain


(* removespace : string -> string *)
(* Removes all spaces from a string *)
fun removespace s = String.translate (fn #" " => "" | c => str c) s

(* to_upper : string -> string *)
(* Convert every char to upper of a string *)
fun to_upper (s : string) : string =
  String.translate (fn c => str (Char.toUpper c)) s

(* convert_to_number : char -> string *)
(* Covert a alphanumeric char into a numerical string *)
fun convert_to_number (c : char) : string =
  if Char.isDigit c then str c else
    if Char.isUpper c then Int.toString (10 + ord c - ord #"A") else
      raise Domain


(* verify_iban : string -> bool *)
(* Check weather a string is a valid IBAN *)
fun verify_iban str =
  let
    (* Remove spaces and make upper case *)
    val str = to_upper (removespace str)
    (* Fetch first two chars (country code) *)
    val country = String.substring (str, 0, 2)
    val len = country_code country
  in
    (* size test *)
    String.size str = len
    andalso
    (* Every char must be alphanumeric *)
    List.all Char.isAlphaNum (explode str)
    andalso
    let
      (* Reorder *)
      val str = String.substring (str, 4, String.size str - 4) ^ String.substring (str, 0, 4)
      (* Convert into digits *)
      val str = String.translate convert_to_number str
      (* Convert into a big number *)
      val number = valOf (IntInf.fromString str)
    in
      IntInf.mod (number, 97) = 1
    end
  end handle Subscript => false | Domain => false
