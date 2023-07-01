(*
 * val mkHtmlTable : ('a list * 'b list) -> ('a -> string * 'b -> string)
 * 			-> (('a * 'b) -> string) -> string
 * The int list is list of colums, the function returns the values
 * at a given colum and row.
 * returns the HTML code of the generated table.
 *)
fun mkHtmlTable (columns, rows) (rowToStr, colToStr) values =
	let
	  val text = ref "<table border=1 cellpadding=10 cellspacing=0>\n<tr><td></td>"
	in
	  (* Add headers *)
	  map (fn colum => text := !text ^ "<th>" ^ (colToStr colum) ^ "</th>") columns;

	  text := !text ^ "</tr>\n";
	  (* Add data rows *)
	  map (fn row =>
		(* row name *)
	  	(text := !text ^ "<tr><th>" ^ (rowToStr row) ^ "</th>";
		(* data *)
		 map (fn col => text := !text ^ "<td>" ^ (values (row, col)) ^ "</td>") columns;
		 text := !text ^ "</tr>\n")
	      ) rows;
	  !text ^ "</table>"
	end

fun mkHtmlWithBody (title, body) = "<html>\n<head>\n<title>" ^ title ^ "</title>\n</head>\n<body>\n" ^ body ^ "\n</body>\n</html>\n"

fun samplePage () = mkHtmlWithBody ("Sample Page",
			mkHtmlTable ([1.0,2.0,3.0,4.0,5.0], [1.0,2.0,3.0,4.0])
			            (Real.toString, Real.toString)
				    (fn (a, b) => Real.toString (Math.pow (a, b))))

val _ = print (samplePage ())
