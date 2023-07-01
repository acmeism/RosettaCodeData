(* AST *)
datatype expression =
	  Con of int				(* constant *)
	| Add of expression * expression	(* addition *)
	| Mul of expression * expression	(* multiplication *)
	| Sub of expression * expression	(* subtraction *)
	| Div of expression * expression	(* division *)

(* Evaluator *)
fun eval (Con x)      = x
  | eval (Add (x, y)) = (eval x)  +  (eval y)
  | eval (Mul (x, y)) = (eval x)  *  (eval y)
  | eval (Sub (x, y)) = (eval x)  -  (eval y)
  | eval (Div (x, y)) = (eval x) div (eval y)

(* Lexer *)
datatype token =
	  CON of int
	| ADD
	| MUL
	| SUB
	| DIV
	| LPAR
	| RPAR

fun lex nil = nil
  | lex (#"+" :: cs) = ADD :: lex cs
  | lex (#"*" :: cs) = MUL :: lex cs
  | lex (#"-" :: cs) = SUB :: lex cs
  | lex (#"/" :: cs) = DIV :: lex cs
  | lex (#"(" :: cs) = LPAR :: lex cs
  | lex (#")" :: cs) = RPAR :: lex cs
  | lex (#"~" :: cs) = if null cs orelse not (Char.isDigit (hd cs)) then raise Domain
                       else lexDigit (0, cs, ~1)
  | lex (c    :: cs) = if Char.isDigit c then lexDigit (0, c :: cs, 1)
                       else raise Domain

and lexDigit (a, cs, s) = if null cs orelse not (Char.isDigit (hd cs)) then CON (a*s) :: lex cs
                          else lexDigit (a * 10 + (ord (hd cs))- (ord #"0") , tl cs, s)

(* Parser *)
exception Error of string

fun match (a,ts) t = if null ts orelse hd ts <> t
                     then raise Error "match"
		     else (a, tl ts)

fun extend (a,ts) p f = let val (a',tr) = p ts in (f(a,a'), tr) end

fun parseE  ts             = parseE' (parseM ts)
and parseE' (e, ADD :: ts) = parseE' (extend (e, ts) parseM Add)
  | parseE' (e, SUB :: ts) = parseE' (extend (e, ts) parseM Sub)
  | parseE' s = s

and parseM  ts             = parseM' (parseP ts)
and parseM' (e, MUL :: ts) = parseM' (extend (e, ts) parseP Mul)
  | parseM' (e, DIV :: ts) = parseM' (extend (e, ts) parseP Div)
  | parseM' s = s

and parseP (CON c :: ts) = (Con c, ts)
  | parseP (LPAR  :: ts) = match (parseE ts) RPAR
  | parseP _ = raise Error "parseP"


(* Test *)
fun lex_parse_eval (str:string) =
	case parseE (lex (explode str)) of
	   (exp, nil) => eval exp
	 | _          => raise Error "not parseable stuff at the end"
