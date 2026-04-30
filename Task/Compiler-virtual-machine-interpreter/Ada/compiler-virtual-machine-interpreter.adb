--
-- The Rosetta Code Virtual Machine, in Ada.
--
-- It is assumed the platform on which this program is run
-- has two's-complement integers. (Otherwise one could modify
-- the vmint_to_vmsigned and vmsigned_to_vmint functions. But
-- the chances your binary integers are not two's-complement
-- seem pretty low.)
--

with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Command_Line;        use Ada.Command_Line;

with Ada.Strings.Unbounded;         use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;

with Ada.Unchecked_Conversion;

procedure VM
is
  bad_vm            : exception;
  vm_limit_exceeded : exception;
  vm_runtime_error  : exception;

  status           : Exit_Status;
  input_file_name  : Unbounded_String;
  output_file_name : Unbounded_String;
  input_file       : File_Type;
  output_file      : File_Type;

-- Some limits of this implementation. You can adjust these to taste.
  strings_size : constant := 2_048;
  stack_size   : constant := 2_048;
  data_size    : constant := 2_048;
  code_size    : constant := 32_768;

  type byte is mod 16#100#;
  type vmint is mod 16#1_0000_0000#;
  subtype vmsigned is Integer range -2_147_483_648 .. 2_147_483_647;

  op_halt  : constant byte := 0;
  op_add   : constant byte := 1;
  op_sub   : constant byte := 2;
  op_mul   : constant byte := 3;
  op_div   : constant byte := 4;
  op_mod   : constant byte := 5;
  op_lt    : constant byte := 6;
  op_gt    : constant byte := 7;
  op_le    : constant byte := 8;
  op_ge    : constant byte := 9;
  op_eq    : constant byte := 10;
  op_ne    : constant byte := 11;
  op_and   : constant byte := 12;
  op_or    : constant byte := 13;
  op_neg   : constant byte := 14;
  op_not   : constant byte := 15;
  op_prtc  : constant byte := 16;
  op_prti  : constant byte := 17;
  op_prts  : constant byte := 18;
  op_fetch : constant byte := 19;
  op_store : constant byte := 20;
  op_push  : constant byte := 21;
  op_jmp   : constant byte := 22;
  op_jz    : constant byte := 23;

  strings : array (0 .. strings_size - 1) of Unbounded_String;
  stack   : array (0 .. stack_size - 1) of vmint;
  data    : array (0 .. data_size - 1) of vmint;
  code    : array (0 .. code_size) of byte;
  sp      : vmint;
  pc      : vmint;

  output_stream : Stream_Access;

  function vmsigned_to_vmint is new Ada.Unchecked_Conversion
   (Source => vmsigned, Target => vmint);

  function vmint_to_vmsigned is new Ada.Unchecked_Conversion
   (Source => vmint, Target => vmsigned);

  function twos_complement
   (x : in vmint)
    return vmint
  is
  begin
    return (not x) + 1;
  end twos_complement;

  function vmint_to_digits
   (x : in vmint)
    return Unbounded_String
  is
    s : Unbounded_String;
    z : vmint;
  begin
    if x = 0 then
      s := To_Unbounded_String ("0");
    else
      s := To_Unbounded_String ("");
      z := x;
      while z /= 0 loop
        s := Character'Val ((z rem 10) + Character'Pos ('0')) & s;
        z := z / 10;
      end loop;
    end if;
    return s;
  end vmint_to_digits;

  function digits_to_vmint
   (s : in String)
    return vmint
  is
    zero     : constant Character := '0';
    zero_pos : constant Integer   := Character'Pos (zero);
    retval   : vmint;
  begin
    if s'Length < 1 then
      raise bad_vm with "expected a numeric literal";
    end if;
    retval := 0;
    for i in s'Range loop
      if Is_Decimal_Digit (s (i)) then
        retval :=
         (10 * retval) + vmint (Character'Pos (s (i)) - zero_pos);
      else
        raise bad_vm with "expected a decimal digit";
      end if;
    end loop;
    return retval;
  end digits_to_vmint;

  function string_to_vmint
   (s : in String)
    return vmint
  is
    retval : vmint;
  begin
    if s'Length < 1 then
      raise bad_vm with "expected a numeric literal";
    end if;
    if s (s'First) = '-' then
      if s'Length < 2 then
        raise bad_vm with "expected a numeric literal";
      end if;
      retval :=
       twos_complement (digits_to_vmint (s (s'First + 1 .. s'Last)));
    else
      retval := digits_to_vmint (s);
    end if;
    return retval;
  end string_to_vmint;

  procedure parse_header
   (s             : in     String;
    data_count    :    out vmint;
    strings_count :    out vmint)
  is
    i : Positive;
    j : Positive;
  begin
    i := s'First;
    while i <= s'Last and then not Is_Decimal_Digit (s (i)) loop
      i := i + 1;
    end loop;

    j := i;
    while j <= s'Last and then Is_Decimal_Digit (s (j)) loop
      j := j + 1;
    end loop;

    data_count := digits_to_vmint (s (i .. j - 1));

    i := j;
    while i <= s'Last and then not Is_Decimal_Digit (s (i)) loop
      i := i + 1;
    end loop;

    j := i;
    while j <= s'Last and then Is_Decimal_Digit (s (j)) loop
      j := j + 1;
    end loop;

    strings_count := digits_to_vmint (s (i .. j - 1));
  end parse_header;

  function parse_string_literal
   (s : in String)
    return Unbounded_String
  is
    t : Unbounded_String;
    i : Positive;

    --
    -- A little trick to get around mistaken highlighting on the
    -- Rosetta Code site.
    --
    quote_string : constant String    := """";
    quote        : constant Character := quote_string (1);

  begin
    t := To_Unbounded_String ("");

    i := s'First;
    while i <= s'Last and then s (i) /= quote loop
      i := i + 1;
    end loop;

    if s'Last < i or else s (i) /= quote then
      raise bad_vm with "expected a '""'";
    end if;

    i := i + 1;
    while i <= s'Last and then s (i) /= quote loop
      if s (i) /= '\' then
        Append (t, s (i));
        i := i + 1;
      elsif s'Last < i + 1 then
        raise bad_vm with "truncated string literal";
      elsif s (i + 1) = 'n' then
        Append (t, Character'Val (10));
        i := i + 2;
      elsif s (i + 1) = '\' then
        Append (t, '\');
        i := i + 2;
      else
        raise bad_vm with "unsupported escape sequence";
      end if;
    end loop;

    return t;
  end parse_string_literal;

  function name_to_opcode
   (s : in String)
    return byte
  is
    retval : byte;
  begin
    if s = "halt" then
      retval := op_halt;
    elsif s = "add" then
      retval := op_add;
    elsif s = "sub" then
      retval := op_sub;
    elsif s = "mul" then
      retval := op_mul;
    elsif s = "div" then
      retval := op_div;
    elsif s = "mod" then
      retval := op_mod;
    elsif s = "lt" then
      retval := op_lt;
    elsif s = "gt" then
      retval := op_gt;
    elsif s = "le" then
      retval := op_le;
    elsif s = "ge" then
      retval := op_ge;
    elsif s = "eq" then
      retval := op_eq;
    elsif s = "ne" then
      retval := op_ne;
    elsif s = "and" then
      retval := op_and;
    elsif s = "or" then
      retval := op_or;
    elsif s = "neg" then
      retval := op_neg;
    elsif s = "not" then
      retval := op_not;
    elsif s = "prtc" then
      retval := op_prtc;
    elsif s = "prti" then
      retval := op_prti;
    elsif s = "prts" then
      retval := op_prts;
    elsif s = "fetch" then
      retval := op_fetch;
    elsif s = "store" then
      retval := op_store;
    elsif s = "push" then
      retval := op_push;
    elsif s = "jmp" then
      retval := op_jmp;
    elsif s = "jz" then
      retval := op_jz;
    else
      raise bad_vm with ("unexpected opcode name");
    end if;
    return retval;
  end name_to_opcode;

  procedure parse_instruction
   (s       : in     String;
    address :    out vmint;
    opcode  :    out byte;
    arg     :    out vmint)
  is
    i : Positive;
    j : Positive;
  begin
    i := s'First;
    while i <= s'Last and then not Is_Decimal_Digit (s (i)) loop
      i := i + 1;
    end loop;

    j := i;
    while j <= s'Last and then Is_Decimal_Digit (s (j)) loop
      j := j + 1;
    end loop;

    address := digits_to_vmint (s (i .. j - 1));

    i := j;
    while i <= s'Last and then not Is_Letter (s (i)) loop
      i := i + 1;
    end loop;

    j := i;
    while j <= s'Last and then Is_Letter (s (j)) loop
      j := j + 1;
    end loop;

    opcode := name_to_opcode (s (i .. j - 1));

    i := j;
    while i <= s'Last and then Is_Space (s (i)) loop
      i := i + 1;
    end loop;

    if s'Last < i then
      arg := 0;
    else
      if not Is_Decimal_Digit (s (i)) and then s (i) /= '-' then
        i := i + 1;
      end if;
      j := i;
      while j <= s'Last
       and then (Is_Decimal_Digit (s (j)) or else s (j) = '-')
      loop
        j := j + 1;
      end loop;
      arg := string_to_vmint (s (i .. j - 1));
    end if;
  end parse_instruction;

  procedure read_and_parse_header
   (data_count    : out vmint;
    strings_count : out vmint)
  is
    line : Unbounded_String;
  begin
    Get_Line (Current_Input, line);
    parse_header (To_String (line), data_count, strings_count);
  end read_and_parse_header;

  procedure read_parse_and_store_strings
   (strings_count : in vmint)
  is
    line : Unbounded_String;
  begin
    if strings_count /= 0 then
      if strings_size < strings_count then
        raise vm_limit_exceeded with "strings limit exceeded";
      end if;
      for i in 0 .. strings_count - 1 loop
        Get_Line (Current_Input, line);
        strings (Integer (i)) :=
         parse_string_literal (To_String (line));
      end loop;
    end if;
  end read_parse_and_store_strings;

  function opcode_takes_arg
   (opcode : in byte)
    return Boolean
  is
    retval : Boolean;
  begin
    if opcode = op_fetch then
      retval := True;
    elsif opcode = op_store then
      retval := True;
    elsif opcode = op_push then
      retval := True;
    elsif opcode = op_jmp then
      retval := True;
    elsif opcode = op_jz then
      retval := True;
    else
      retval := False;
    end if;
    return retval;
  end opcode_takes_arg;

  procedure read_parse_and_store_instructions
  is
    line    : Unbounded_String;
    address : vmint;
    opcode  : byte;
    arg     : vmint;
    j       : Positive;
  begin
    while not End_Of_File (Current_Input) loop
      Get_Line (Current_Input, line);

      j := 1;
      while j <= Length (line) and then Is_Space (Element (line, j))
      loop
        j := j + 1;
      end loop;

      if j <= Length (line) then
        parse_instruction (To_String (line), address, opcode, arg);
        if opcode_takes_arg (opcode) then
          if code_size - 4 <= address then
            raise vm_limit_exceeded with "code space limit exceeded";
          end if;
          code (Integer (address)) := opcode;
          --
          -- Little-endian storage.
          --
          code (Integer (address) + 1) := byte (arg and 16#FF#);
          code (Integer (address) + 2) :=
           byte ((arg / 16#100#) and 16#FF#);
          code (Integer (address) + 3) :=
           byte ((arg / 16#1_0000#) and 16#FF#);
          code (Integer (address) + 4) :=
           byte ((arg / 16#100_0000#) and 16#FF#);
        else
          if code_size <= address then
            raise vm_limit_exceeded with "code space limit exceeded";
          end if;
          code (Integer (address)) := opcode;
        end if;
      end if;
    end loop;
  end read_parse_and_store_instructions;

  procedure read_parse_and_store_program
  is
    data_count    : vmint;
    strings_count : vmint;
  begin
    read_and_parse_header (data_count, strings_count);
    read_parse_and_store_strings (strings_count);
    read_parse_and_store_instructions;
  end read_parse_and_store_program;

  procedure pop_value
   (x : out vmint)
  is
  begin
    if sp = 0 then
      raise vm_runtime_error with "stack underflow";
    end if;
    sp := sp - 1;
    x  := stack (Integer (sp));
  end pop_value;

  procedure push_value
   (x : in vmint)
  is
  begin
    if stack_size <= sp then
      raise vm_runtime_error with "stack overflow";
    end if;
    stack (Integer (sp)) := x;
    sp                   := sp + 1;
  end push_value;

  procedure get_value
   (x : out vmint)
  is
  begin
    if sp = 0 then
      raise vm_runtime_error with "stack underflow";
    end if;
    x := stack (Integer (sp) - 1);
  end get_value;

  procedure put_value
   (x : in vmint)
  is
  begin
    if sp = 0 then
      raise vm_runtime_error with "stack underflow";
    end if;
    stack (Integer (sp) - 1) := x;
  end put_value;

  procedure fetch_value
   (i : in     vmint;
    x :    out vmint)
  is
  begin
    if data_size <= i then
      raise vm_runtime_error with "data boundary exceeded";
    end if;
    x := data (Integer (i));
  end fetch_value;

  procedure store_value
   (i : in vmint;
    x : in vmint)
  is
  begin
    if data_size <= i then
      raise vm_runtime_error with "data boundary exceeded";
    end if;
    data (Integer (i)) := x;
  end store_value;

  procedure immediate_value
   (x : out vmint)
  is
    b0, b1, b2, b3 : vmint;
  begin
    if code_size - 4 <= pc then
      raise vm_runtime_error with "code boundary exceeded";
    end if;
    --
    -- Little-endian order.
    --
    b0 := vmint (code (Integer (pc)));
    b1 := vmint (code (Integer (pc) + 1));
    b2 := vmint (code (Integer (pc) + 2));
    b3 := vmint (code (Integer (pc) + 3));
    x  :=
     b0 + (16#100# * b1) + (16#1_0000# * b2) + (16#100_0000# * b3);
  end immediate_value;

  procedure machine_add
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    put_value (x + y);
  end machine_add;

  procedure machine_sub
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    put_value (x - y);
  end machine_sub;

  procedure machine_mul
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    put_value
     (vmsigned_to_vmint
       (vmint_to_vmsigned (x) * vmint_to_vmsigned (y)));
  end machine_mul;

  procedure machine_div
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    put_value
     (vmsigned_to_vmint
       (vmint_to_vmsigned (x) / vmint_to_vmsigned (y)));
  end machine_div;

  procedure machine_mod
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    put_value
     (vmsigned_to_vmint
       (vmint_to_vmsigned (x) rem vmint_to_vmsigned (y)));
  end machine_mod;

  procedure machine_lt
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if vmint_to_vmsigned (x) < vmint_to_vmsigned (y) then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_lt;

  procedure machine_gt
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if vmint_to_vmsigned (x) > vmint_to_vmsigned (y) then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_gt;

  procedure machine_le
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if vmint_to_vmsigned (x) <= vmint_to_vmsigned (y) then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_le;

  procedure machine_ge
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if vmint_to_vmsigned (x) >= vmint_to_vmsigned (y) then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_ge;

  procedure machine_eq
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if x = y then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_eq;

  procedure machine_ne
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if x /= y then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_ne;

  procedure machine_and
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if x /= 0 and y /= 0 then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_and;

  procedure machine_or
  is
    x, y : vmint;
  begin
    pop_value (y);
    get_value (x);
    if x /= 0 or y /= 0 then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_or;

  procedure machine_neg
  is
    x : vmint;
  begin
    get_value (x);
    put_value (twos_complement (x));
  end machine_neg;

  procedure machine_not
  is
    x : vmint;
  begin
    get_value (x);
    if x = 0 then
      put_value (1);
    else
      put_value (0);
    end if;
  end machine_not;

  procedure machine_prtc
  is
    x : vmint;
  begin
    pop_value (x);
    Character'Write (output_stream, Character'Val (x));
  end machine_prtc;

  procedure machine_prti
  is
    x : vmint;
  begin
    pop_value (x);
    if 16#7FFF_FFFF# < x then
      Character'Write (output_stream, '-');
      String'Write
       (output_stream,
        To_String (vmint_to_digits (twos_complement (x))));
    else
      String'Write (output_stream, To_String (vmint_to_digits (x)));
    end if;
  end machine_prti;

  procedure machine_prts
  is
    k : vmint;
  begin
    pop_value (k);
    if strings_size <= k then
      raise vm_runtime_error with "strings boundary exceeded";
    end if;
    String'Write (output_stream, To_String (strings (Integer (k))));
  end machine_prts;

  procedure machine_fetch
  is
    k : vmint;
    x : vmint;
  begin
    immediate_value (k);
    fetch_value (k, x);
    push_value (x);
    pc := pc + 4;
  end machine_fetch;

  procedure machine_store
  is
    k : vmint;
    x : vmint;
  begin
    immediate_value (k);
    pop_value (x);
    store_value (k, x);
    pc := pc + 4;
  end machine_store;

  procedure machine_push
  is
    x : vmint;
  begin
    immediate_value (x);
    push_value (x);
    pc := pc + 4;
  end machine_push;

  procedure machine_jmp
  is
    offset : vmint;
  begin
    immediate_value (offset);
    pc := pc + offset;
  end machine_jmp;

  procedure machine_jz
  is
    x      : vmint;
    offset : vmint;
  begin
    pop_value (x);
    if x = 0 then
      immediate_value (offset);
      pc := pc + offset;
    else
      pc := pc + 4;
    end if;
  end machine_jz;

  procedure machine_step
   (halt : out Boolean)
  is
    opcode             : byte;
    op_div_4, op_rem_4 : byte;
  begin
    if code_size <= pc then
      raise vm_runtime_error with "code boundary exceeded";
    end if;
    opcode   := code (Integer (pc));
    pc       := pc + 1;
    halt     := False;
    op_div_4 := opcode / 4;
    op_rem_4 := opcode rem 4;
    if op_div_4 = 0 then
      if op_rem_4 = 0 then
        halt := True;
      elsif op_rem_4 = 1 then
        machine_add;
      elsif op_rem_4 = 2 then
        machine_sub;
      else
        machine_mul;
      end if;
    elsif op_div_4 = 1 then
      if op_rem_4 = 0 then
        machine_div;
      elsif op_rem_4 = 1 then
        machine_mod;
      elsif op_rem_4 = 2 then
        machine_lt;
      else
        machine_gt;
      end if;
    elsif op_div_4 = 2 then
      if op_rem_4 = 0 then
        machine_le;
      elsif op_rem_4 = 1 then
        machine_ge;
      elsif op_rem_4 = 2 then
        machine_eq;
      else
        machine_ne;
      end if;
    elsif op_div_4 = 3 then
      if op_rem_4 = 0 then
        machine_and;
      elsif op_rem_4 = 1 then
        machine_or;
      elsif op_rem_4 = 2 then
        machine_neg;
      else
        machine_not;
      end if;
    elsif op_div_4 = 4 then
      if op_rem_4 = 0 then
        machine_prtc;
      elsif op_rem_4 = 1 then
        machine_prti;
      elsif op_rem_4 = 2 then
        machine_prts;
      else
        machine_fetch;
      end if;
    elsif op_div_4 = 5 then
      if op_rem_4 = 0 then
        machine_store;
      elsif op_rem_4 = 1 then
        machine_push;
      elsif op_rem_4 = 2 then
        machine_jmp;
      else
        machine_jz;
      end if;
    else
      -- Treat anything unrecognized as equivalent to a halt.
      halt := True;
    end if;
  end machine_step;

  procedure machine_continue
  is
    halt : Boolean;
  begin
    halt := False;
    while not halt loop
      machine_step (halt);
    end loop;
  end machine_continue;

  procedure machine_run
  is
  begin
    sp := 0;
    pc := 0;
    for i in data'Range loop
      data (i) := 0;
    end loop;
    machine_continue;
  end machine_run;

begin
  status := 0;

  input_file_name := To_Unbounded_String ("-");

  if Argument_Count = 0 then
    null;
  elsif Argument_Count = 1 then
    input_file_name := To_Unbounded_String (Argument (1));
  else
    Put ("Usage: ");
    Put (Command_Name);
    Put_Line (" [INPUTFILE]");
    Put ("If either INPUTFILE is missing or ""-"",");
    Put_Line (" standard input is used.");
    Put_Line ("Output is always to standard output.");
    status := 1;
  end if;

  if status = 0 then
    if input_file_name /= "-" then
      Open (input_file, In_File, To_String (input_file_name));
      Set_Input (input_file);
    end if;

    output_stream := Stream (Current_Output);
    read_parse_and_store_program;
    machine_run;

    if input_file_name /= "-" then
      Set_Input (Standard_Input);
      Close (input_file);
    end if;
  end if;

  Set_Exit_Status (status);
end VM;
