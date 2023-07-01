structure Operator = struct
  datatype associativity = LEFT | RIGHT
  type operator = { symbol : char, assoc : associativity, precedence : int }

  val operators : operator list = [
    { symbol = #"^", precedence = 4, assoc = RIGHT },
    { symbol = #"*", precedence = 3, assoc = LEFT },
    { symbol = #"/", precedence = 3, assoc = LEFT },
    { symbol = #"+", precedence = 2, assoc = LEFT },
    { symbol = #"-", precedence = 2, assoc = LEFT }
  ]

  fun find (c : char) : operator option = List.find (fn ({symbol, ...} : operator) => symbol = c) operators

  infix cmp
  fun ({precedence=p1, assoc=a1, ...} : operator) cmp ({precedence=p2, ...} : operator) =
    case a1 of
      LEFT => p1 <= p2
    | RIGHT => p1 < p2
end

signature SHUNTING_YARD = sig
  type 'a tree
  type content

  val parse : string -> content tree
end

structure ShuntingYard : SHUNTING_YARD = struct
  structure O = Operator
  val cmp = O.cmp
  (* did you know infixity doesn't "carry out" of a structure unless you open it? TIL *)
  infix cmp
  fun pop2 (b::a::rest) = ((a, b), rest)
    | pop2 _ = raise Fail "bad input"

  datatype content = Op of char
                   | Int of int
  datatype 'a tree = Leaf
                   | Node of 'a tree * 'a * 'a tree

  fun parse_int' tokens curr = case tokens of
      [] => (List.rev curr, [])
    | t::ts => if Char.isDigit t then parse_int' ts (t::curr)
               else (List.rev curr, t::ts)

  fun parse_int tokens = let
    val (int_chars, rest) = parse_int' tokens []
  in
    ((Option.valOf o Int.fromString o String.implode) int_chars, rest)
  end

  fun parse (s : string) : content tree = let
    val tokens = String.explode s
    (* parse': tokens operator_stack trees *)
    fun parse' [] [] [result] = result
      | parse' [] (opr::os) trees =
          if opr = #"(" orelse opr = #")" then raise Fail "bad input"
          else let
            val ((a,b), trees') = pop2 trees
            val trees'' = (Node (a, Op opr, b)) :: trees'
          in
            parse' [] os trees''
          end
      | parse' (t::ts) operators trees =
          if Char.isSpace t then parse' ts operators trees else
          if t = #"(" then parse' ts (t::operators) (trees : content tree list) else
          if t = #")" then let
            (* process_operators : operators trees *)
            fun process_operators [] _ = raise Fail "bad input"
              | process_operators (opr::os) trees =
                  if opr = #"(" then (os, trees)
                  else let
                    val ((a, b), trees') = pop2 trees
                    val trees'' = (Node (a, Op opr, b)) :: trees'
                  in
                    process_operators os trees''
                  end
            val (operators', trees') = process_operators (operators : char list) (trees : content tree list)
          in
            parse' ts operators' trees'
          end else
          (case O.find (t : char) of
            SOME o1 => let
              (* process_operators : operators trees *)
              fun process_operators [] trees = ([], trees)
                | process_operators (o2::os) trees = (case O.find o2 of
                    SOME o2 =>
                      if o1 cmp o2 then let
                        val ((a, b), trees') = pop2 trees
                        val trees'' = (Node (a, Op (#symbol o2), b)) :: trees'
                      in
                        process_operators os trees''
                      end
                      else ((#symbol o2)::os, trees)
                  | NONE => (o2::os, trees))
              val (operators', trees') = process_operators operators trees
            in
              parse' ts ((#symbol o1)::operators') trees'
            end
          | NONE => let
              val (n, tokens') = parse_int (t::ts)
            in
              parse' tokens' operators ((Node (Leaf, Int n, Leaf)) :: trees)
            end)
      | parse' _ _ _ = raise Fail "bad input"
  in
    parse' tokens [] []
  end
end
