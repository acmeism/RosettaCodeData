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

function emit_byte(x) {
  code[next_free_code_index++] = x
}

function emit_word(x,       i) {
  for (i=0; i<word_size; i++) {
    emit_byte(int(x)%256);
    x = int(x/256)
  }
}

function run_vm(data_size) {
  sp = data_size + 1
  pc = 0
  while (1) {
    op = code[pc++]
    if (op == FETCH) {
      stack[sp++] = stack[bytes_to_int(pc)]
      pc += word_size
    } else if (op == STORE) {
      stack[bytes_to_int(pc)] = stack[--sp]
      pc += word_size
    } else if (op == PUSH) {
      stack[sp++] = bytes_to_int(pc)
      pc += word_size
    } else if (op == ADD ) { stack[sp-2] += stack[sp-1]; sp--
    } else if (op == SUB ) { stack[sp-2] -= stack[sp-1]; sp--
    } else if (op == MUL ) { stack[sp-2] *= stack[sp-1]; sp--
    } else if (op == DIV ) { stack[sp-2]  = int(stack[sp-2] / stack[sp-1]); sp--
    } else if (op == MOD ) { stack[sp-2] %= stack[sp-1]; sp--
    } else if (op == LT  ) { stack[sp-2] = stack[sp-2] <  stack[sp-1]; sp--
    } else if (op == GT  ) { stack[sp-2] = stack[sp-2] >  stack[sp-1]; sp--
    } else if (op == LE  ) { stack[sp-2] = stack[sp-2] <= stack[sp-1]; sp--
    } else if (op == GE  ) { stack[sp-2] = stack[sp-2] >= stack[sp-1]; sp--
    } else if (op == EQ  ) { stack[sp-2] = stack[sp-2] == stack[sp-1]; sp--
    } else if (op == NE  ) { stack[sp-2] = stack[sp-2] != stack[sp-1]; sp--
    } else if (op == AND ) { stack[sp-2] = stack[sp-2] && stack[sp-1]; sp--
    } else if (op == OR  ) { stack[sp-2] = stack[sp-2] || stack[sp-1]; sp--
    } else if (op == NEG ) { stack[sp-1] = - stack[sp-1]
    } else if (op == NOT ) { stack[sp-1] = ! stack[sp-1]
    } else if (op == JMP ) { pc += bytes_to_int(pc)
    } else if (op == JZ  ) { if (stack[--sp]) { pc += word_size } else { pc += bytes_to_int(pc) }
    } else if (op == PRTC) { printf("%c", stack[--sp])
    } else if (op == PRTS) { printf("%s", string_pool[stack[--sp]])
    } else if (op == PRTI) { printf("%d", stack[--sp])
    } else if (op == HALT) { break
    }
  } # while
}

function str_trans(srce,           dest, i) {
  dest = ""
  for (i=1; i <= length(srce); ) {
    if (substr(srce, i, 1) == "\\" && i < length(srce)) {
      if (substr(srce, i+1, 1) == "n") {
        dest = dest "\n"
        i += 2
      } else if (substr(srce, i+1, 1) == "\\") {
        dest = dest "\\"
        i += 2
      }
    } else {
      dest = dest substr(srce, i, 1)
      i += 1
    }
  }
  return dest
}

function load_code(            n, i) {
  getline line
  if (line ==  "")
    error("empty line")
  n=split(line, line_list)
  data_size = line_list[2]
  n_strings = line_list[4]
  for (i=0; i<n_strings; i++) {
    getline line
    gsub(/\n/, "", line)
    gsub(/"/ , "", line)
    string_pool[i] = str_trans(line)
  }
  while (getline) {
    offset = int($1)
    instr  = $2
    opcode = code_map[instr]
    if (opcode == "")
      error("Unknown instruction " instr " at " offset)
    emit_byte(opcode)
    if (opcode == JMP || opcode == JZ) {
      p = int($4)
      emit_word(p - (offset + 1))
    } else if (opcode == PUSH) {
      value = int($3)
      emit_word(value)
    } else if (opcode == FETCH || opcode == STORE) {
      gsub(/\[/, "", $3)
      gsub(/\]/, "", $3)
      value = int($3)
      emit_word(value)
    }
  }
  return data_size
}

BEGIN {
  code_map["fetch"] = FETCH =  1
  code_map["store"] = STORE =  2
  code_map["push" ] = PUSH  =  3
  code_map["add"  ] = ADD   =  4
  code_map["sub"  ] = SUB   =  5
  code_map["mul"  ] = MUL   =  6
  code_map["div"  ] = DIV   =  7
  code_map["mod"  ] = MOD   =  8
  code_map["lt"   ] = LT    =  9
  code_map["gt"   ] = GT    = 10
  code_map["le"   ] = LE    = 11
  code_map["ge"   ] = GE    = 12
  code_map["eq"   ] = EQ    = 13
  code_map["ne"   ] = NE    = 14
  code_map["and"  ] = AND   = 15
  code_map["or"   ] = OR    = 16
  code_map["neg"  ] = NEG   = 17
  code_map["not"  ] = NOT   = 18
  code_map["jmp"  ] = JMP   = 19
  code_map["jz"   ] = JZ    = 20
  code_map["prtc" ] = PRTC  = 21
  code_map["prts" ] = PRTS  = 22
  code_map["prti" ] = PRTI  = 23
  code_map["halt" ] = HALT  = 24

  next_free_node_index = 1
  next_free_code_index = 0
  word_size   = 4
  input_file = "-"
  if (ARGC > 1)
    input_file = ARGV[1]
  data_size = load_code()
  run_vm(data_size)
}
