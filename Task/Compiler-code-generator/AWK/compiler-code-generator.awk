function error(msg) {
  printf("%s\n", msg)
  exit(1)
}

function bytes_to_int(bstr,          i, sum) {
  sum = 0
  for (i=word_size-1; i>=0; i--) {
    sum *= 256
    sum += code[bstr+i]
  }
  return sum
}

function make_node(oper, left, right, value) {
  node_type [next_free_node_index] = oper
  node_left [next_free_node_index] = left
  node_right[next_free_node_index] = right
  node_value[next_free_node_index] = value
  return next_free_node_index ++
}

function make_leaf(oper, n) {
  return make_node(oper, 0, 0, n)
}

function emit_byte(x) {
  code[next_free_code_index++] = x
}

function emit_word(x,       i) {
  for (i=0; i<word_size; i++) {
    emit_byte(int(x)%256);
    x = int(x/256)
  }
}

function emit_word_at(at, n,             i) {
  for (i=0; i<word_size; i++) {
    code[at+i] = int(n)%256
    n = int(n/256)
  }
}

function hole(         t) {
  t = next_free_code_index
  emit_word(0)
  return t
}

function fetch_var_offset(name,       n) {
  if (name in globals) {
    n = globals[name]
  } else {
    globals[name] = globals_n
    n = globals_n
    globals_n += 1
  }
  return n
}

function fetch_string_offset(the_string,        n) {
  n = string_pool[the_string]
  if (n == "") {
    string_pool[the_string] = string_n
    n = string_n
    string_n += 1
  }
  return n
}

function code_gen(x,       n, p1, p2) {
  if (x == 0) {
    return
  } else if (node_type[x] == "nd_Ident") {
    emit_byte(FETCH)
    n = fetch_var_offset(node_value[x])
    emit_word(n)
  } else if (node_type[x] == "nd_Integer") {
    emit_byte(PUSH)
    emit_word(node_value[x])
  } else if (node_type[x] == "nd_String") {
    emit_byte(PUSH)
    n = fetch_string_offset(node_value[x])
    emit_word(n)
  } else if (node_type[x] == "nd_Assign") {
    n = fetch_var_offset(node_value[node_left[x]])
    code_gen(node_right[x])
    emit_byte(STORE)
    emit_word(n)
  } else if (node_type[x] == "nd_If") {
    code_gen(node_left[x])        # expr
    emit_byte(JZ)                 # if false, jump
    p1 = hole()                   # make room for jump dest
    code_gen(node_left[node_right[x]])        # if true statements
    if (node_right[node_right[x]] != 0) {
      emit_byte(JMP)            # jump over else statements
      p2 = hole()
    }
    emit_word_at(p1, next_free_code_index - p1)
    if (node_right[node_right[x]] != 0) {
      code_gen(node_right[node_right[x]])   # else statements
      emit_word_at(p2, next_free_code_index - p2)
    }
  } else if (node_type[x] == "nd_While") {
    p1 =next_free_code_index
    code_gen(node_left[x])
    emit_byte(JZ)
    p2 = hole()
    code_gen(node_right[x])
    emit_byte(JMP)                       # jump back to the top
    emit_word(p1 - next_free_code_index)
    emit_word_at(p2, next_free_code_index - p2)
  } else if (node_type[x] == "nd_Sequence") {
    code_gen(node_left[x])
    code_gen(node_right[x])
  } else if (node_type[x] == "nd_Prtc") {
    code_gen(node_left[x])
    emit_byte(PRTC)
  } else if (node_type[x] == "nd_Prti") {
    code_gen(node_left[x])
    emit_byte(PRTI)
  } else if (node_type[x] == "nd_Prts") {
    code_gen(node_left[x])
    emit_byte(PRTS)
  } else if (node_type[x] in operators) {
    code_gen(node_left[x])
    code_gen(node_right[x])
    emit_byte(operators[node_type[x]])
  } else if (node_type[x] in unary_operators) {
    code_gen(node_left[x])
    emit_byte(unary_operators[node_type[x]])
  } else {
    error("error in code generator - found '" node_type[x] "', expecting operator")
  }
}

function code_finish() {
  emit_byte(HALT)
}

function list_code() {
  printf("Datasize: %d Strings: %d\n", globals_n, string_n)
  # Make sure that arrays are sorted by value in ascending order.
  PROCINFO["sorted_in"] =  "@val_str_asc"
  # This is a dependency on GAWK.
  for (k in string_pool)
    print(k)
  pc = 0
  while (pc < next_free_code_index) {
    printf("%4d ", pc)
    op = code[pc]
    pc += 1
    if (op == FETCH) {
      x = bytes_to_int(pc)
      printf("fetch [%d]\n", x);
      pc += word_size
    } else if (op == STORE) {
      x = bytes_to_int(pc)
      printf("store [%d]\n", x);
      pc += word_size
    } else if (op == PUSH) {
      x = bytes_to_int(pc)
      printf("push  %d\n", x);
      pc += word_size
    } else if (op == ADD)  {  print("add")
    } else if (op == SUB)  {  print("sub")
    } else if (op == MUL)  {  print("mul")
    } else if (op == DIV)  {  print("div")
    } else if (op == MOD)  {  print("mod")
    } else if (op == LT)   {  print("lt")
    } else if (op == GT)   {  print("gt")
    } else if (op == LE)   {  print("le")
    } else if (op == GE)   {  print("ge")
    } else if (op == EQ)   {  print("eq")
    } else if (op == NE)   {  print("ne")
    } else if (op == AND)  {  print("and")
    } else if (op == OR)   {  print("or")
    } else if (op == NEG)  {  print("neg")
    } else if (op == NOT)  {  print("not")
    } else if (op == JMP)  {
      x = bytes_to_int(pc)
      printf("jmp    (%d) %d\n", x, pc + x);
      pc += word_size
    } else if (op == JZ)  {
      x = bytes_to_int(pc)
      printf("jz     (%d) %d\n", x, pc + x);
      pc += word_size
    } else if (op == PRTC) { print("prtc")
    } else if (op == PRTI) { print("prti")
    } else if (op == PRTS) { print("prts")
    } else if (op == HALT) { print("halt")
    } else                 { error("list_code: Unknown opcode '" op "'")
    }
  } # while pc
}

function load_ast(        line, line_list, text, n, node_type, value, left, right) {
  getline line
  n=split(line, line_list)
  text = line_list[1]
  if (text == ";")
    return 0
  node_type = all_syms[text]
  if (n > 1) {
    value = line_list[2]
    for (i=3;i<=n;i++)
      value = value " " line_list[i]
    if (value ~ /^[0-9]+$/)
      value = int(value)
    return make_leaf(node_type, value)
  }
  left = load_ast()
  right = load_ast()
  return make_node(node_type, left, right)
}

BEGIN {
  all_syms["Identifier"  ] = "nd_Ident"
  all_syms["String"      ] = "nd_String"
  all_syms["Integer"     ] = "nd_Integer"
  all_syms["Sequence"    ] = "nd_Sequence"
  all_syms["If"          ] = "nd_If"
  all_syms["Prtc"        ] = "nd_Prtc"
  all_syms["Prts"        ] = "nd_Prts"
  all_syms["Prti"        ] = "nd_Prti"
  all_syms["While"       ] = "nd_While"
  all_syms["Assign"      ] = "nd_Assign"
  all_syms["Negate"      ] = "nd_Negate"
  all_syms["Not"         ] = "nd_Not"
  all_syms["Multiply"    ] = "nd_Mul"
  all_syms["Divide"      ] = "nd_Div"
  all_syms["Mod"         ] = "nd_Mod"
  all_syms["Add"         ] = "nd_Add"
  all_syms["Subtract"    ] = "nd_Sub"
  all_syms["Less"        ] = "nd_Lss"
  all_syms["LessEqual"   ] = "nd_Leq"
  all_syms["Greater"     ] = "nd_Gtr"
  all_syms["GreaterEqual"] = "nd_Geq"
  all_syms["Equal"       ] = "nd_Eql"
  all_syms["NotEqual"    ] = "nd_Neq"
  all_syms["And"         ] = "nd_And"
  all_syms["Or"          ] = "nd_Or"

  FETCH=1; STORE=2; PUSH=3; ADD=4; SUB=5; MUL=6;
  DIV=7; MOD=8; LT=9; GT=10; LE=11; GE=12;
  EQ=13; NE=14; AND=15; OR=16; NEG=17; NOT=18;
  JMP=19; JZ=20; PRTC=21; PRTS=22; PRTI=23; HALT=24;

  operators["nd_Lss"] = LT
  operators["nd_Gtr"] = GT
  operators["nd_Leq"] = LE
  operators["nd_Geq"] = GE
  operators["nd_Eql"] = EQ
  operators["nd_Neq"] = NE
  operators["nd_And"] = AND
  operators["nd_Or" ] = OR
  operators["nd_Sub"] = SUB
  operators["nd_Add"] = ADD
  operators["nd_Div"] = DIV
  operators["nd_Mul"] = MUL
  operators["nd_Mod"] = MOD

  unary_operators["nd_Negate"] = NEG
  unary_operators["nd_Not"   ] = NOT

  next_free_node_index = 1
  next_free_code_index = 0
  globals_n   = 0
  string_n    = 0
  word_size   = 4
  input_file = "-"

  if (ARGC > 1)
    input_file = ARGV[1]
  n = load_ast()
  code_gen(n)
  code_finish()
  list_code()
}
