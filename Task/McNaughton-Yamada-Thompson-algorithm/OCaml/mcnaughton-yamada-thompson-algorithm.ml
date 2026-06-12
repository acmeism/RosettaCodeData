open Printf

(* State type for NFA *)
type state = {
  mutable edge1: state option;
  mutable edge2: state option;
  label: char;
}

(* NFA type *)
type nfa = {
  initial: state;
  accept: state;
}

(* Create a new state *)
let make_state label =
  { edge1 = None; edge2 = None; label }

let make_epsilon_state () = make_state '\000'

(* Convert infix regex to postfix using Shunting Yard algorithm *)
let shunt infix =
  let precedence = function
    | '*' -> 60
    | '+' -> 55
    | '?' -> 50
    | '.' -> 40
    | '|' -> 20
    | _ -> 0
  in

  let stack = Stack.create () in
  let postfix = Buffer.create (String.length infix) in

  String.iter (function
    | '(' -> Stack.push '(' stack
    | ')' ->
        (try
          while Stack.top stack <> '(' do
            Buffer.add_char postfix (Stack.pop stack)
          done;
          ignore (Stack.pop stack) (* Remove '(' *)
        with Stack.Empty -> ())
    | ch when List.mem ch ['*'; '+'; '?'; '.'; '|'] ->
        (try
          while not (Stack.is_empty stack) &&
                Stack.top stack <> '(' &&
                precedence ch <= precedence (Stack.top stack) do
            Buffer.add_char postfix (Stack.pop stack)
          done
        with Stack.Empty -> ());
        Stack.push ch stack
    | ch -> Buffer.add_char postfix ch
  ) infix;

  (try
    while true do
      Buffer.add_char postfix (Stack.pop stack)
    done
  with Stack.Empty -> ());

  Buffer.contents postfix

(* Compute epsilon closure of a state *)
let followes state =
  let visited = Hashtbl.create 16 in
  let stack = Stack.create () in
  let result = ref [] in

  Stack.push state stack;

  while not (Stack.is_empty stack) do
    let current = Stack.pop stack in
    if not (Hashtbl.mem visited current) then begin
      Hashtbl.add visited current ();
      result := current :: !result;
      if current.label = '\000' then begin (* Epsilon transition *)
        (match current.edge1 with Some s -> Stack.push s stack | None -> ());
        (match current.edge2 with Some s -> Stack.push s stack | None -> ())
      end
    end
  done;

  !result

(* Compile postfix regex into NFA *)
let compile_regex postfix =
  let stack = Stack.create () in

  String.iter (function
    | '*' ->
        let nfa1 = Stack.pop stack in
        let initial = make_epsilon_state () in
        let accept = make_epsilon_state () in
        initial.edge1 <- Some nfa1.initial;
        initial.edge2 <- Some accept;
        nfa1.accept.edge1 <- Some nfa1.initial;
        nfa1.accept.edge2 <- Some accept;
        Stack.push { initial; accept } stack

    | '.' ->
        let nfa2 = Stack.pop stack in
        let nfa1 = Stack.pop stack in
        nfa1.accept.edge1 <- Some nfa2.initial;
        Stack.push { initial = nfa1.initial; accept = nfa2.accept } stack

    | '|' ->
        let nfa2 = Stack.pop stack in
        let nfa1 = Stack.pop stack in
        let initial = make_epsilon_state () in
        let accept = make_epsilon_state () in
        initial.edge1 <- Some nfa1.initial;
        initial.edge2 <- Some nfa2.initial;
        nfa1.accept.edge1 <- Some accept;
        nfa2.accept.edge1 <- Some accept;
        Stack.push { initial; accept } stack

    | '+' ->
        let nfa1 = Stack.pop stack in
        let initial = make_epsilon_state () in
        let accept = make_epsilon_state () in
        initial.edge1 <- Some nfa1.initial;
        nfa1.accept.edge1 <- Some nfa1.initial;
        nfa1.accept.edge2 <- Some accept;
        Stack.push { initial; accept } stack

    | '?' ->
        let nfa1 = Stack.pop stack in
        let initial = make_epsilon_state () in
        let accept = make_epsilon_state () in
        initial.edge1 <- Some nfa1.initial;
        initial.edge2 <- Some accept;
        nfa1.accept.edge1 <- Some accept;
        Stack.push { initial; accept } stack

    | ch -> (* Literal character *)
        let initial = make_state ch in
        let accept = make_epsilon_state () in
        initial.edge1 <- Some accept;
        Stack.push { initial; accept } stack
  ) postfix;

  Stack.top stack

(* Match string against infix regex *)
let match_regex text infix =
  let postfix = shunt infix in
  (* Uncomment the next line to see the postfix expression *)
  (* printf "Postfix: %s\n" postfix; *)

  let nfa = compile_regex postfix in

  let current = ref (followes nfa.initial) in

  String.iter (fun ch ->
    let next_states = ref [] in
    List.iter (fun state ->
      if state.label = ch then
        match state.edge1 with
        | Some next_state ->
            let follow = followes next_state in
            next_states := follow @ !next_states
        | None -> ()
    ) !current;
    current := !next_states
  ) text;

  List.mem nfa.accept !current

(* Main function *)
let () =
  let infixes = [
    "a.b.c*"; "a.(b|d).c*"
    (*"(a.(b|d))*";*)
    (*"a.(b.b)*.c" *)
    ] in
  let strings = [""; "abc"; "abbc"; "abcc"; "abad"; "abbbc"] in

  List.iter (fun infix ->
    List.iter (fun string ->
      let result = match_regex string infix in
      printf "%s %s %s\n" (if result then "True " else "False") infix string
    ) strings;
    printf "\n"
  ) infixes
