val stripComment =
  let
    val notMarker = fn #"#" => false | #";" => false | _ => true
    open Substring
  in
    string o dropr Char.isSpace o takel notMarker o full
  end
