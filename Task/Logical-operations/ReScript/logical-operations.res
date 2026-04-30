let logic = (a, b) => {
  Js.log(string_of_bool(a) ++ " and " ++ string_of_bool(b) ++ " = " ++ string_of_bool(a && b))
  Js.log(string_of_bool(a) ++ " or " ++ string_of_bool(b) ++ " = " ++ string_of_bool(a || b))
}

let logic2 = (a) =>
  Js.log("not(" ++ string_of_bool(a) ++ ") = " ++ string_of_bool(!a))

logic(true, true)
logic(true, false)
logic(false, true)
logic(false, false)

logic2(true)
logic2(false)
