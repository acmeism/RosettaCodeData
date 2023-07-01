create or replace function rpn_calc(str varchar2) return number as
  type  num_aa    is table of number index by pls_integer;
  type  num_stack is record (a num_aa, top pls_integer default 0);
  ns    num_stack;
  pos1  integer := 1;
  pos2  integer;
  token varchar2(100);
  op2   number;
  procedure push(s in out nocopy num_stack, x number) is
    begin
      s.top := s.top + 1;
      s.a(s.top) := x;
    end;
  function pop(s in out nocopy num_stack) return number is
      x number;
    begin
      x := s.a(s.top);
      s.top := s.top - 1;
      return x;
    end;
  procedure print_stack(s num_stack) is  -- for debugging only; remove from final version
      ps varchar2(4000);
    begin
      for i in 1 .. s.top loop
        ps := ps || s.a(i) || ' ';
      end loop;
      dbms_output.put_line('Stack: ' || rtrim(ps));
    end;
begin
  while pos1 <= length(str) loop
    pos2  := instr(str || ' ', ' ', pos1);
    token := substr(str, pos1, pos2 - pos1);
    pos1  := pos2 + 1;
    case token
         when '+' then push(ns, pop(ns) + pop(ns));
         when '-' then op2 := pop(ns); push(ns, pop(ns) - op2);
         when '*' then push(ns, pop(ns) * pop(ns));
         when '/' then op2 := pop(ns); push(ns, pop(ns) / op2);
         when '^' then op2 := pop(ns); push(ns, power(pop(ns), op2));
         else push(ns, to_number(token));
    end case;
    print_stack(ns);    -- for debugging purposes only
  end loop;
  return pop(ns);
end rpn_calc;
/
