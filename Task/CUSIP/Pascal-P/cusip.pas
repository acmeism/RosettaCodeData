program cusip(output);

const
  cusiplen = 9;

type
  tcusip = array [1 .. cusiplen] of char;

  function cusipcheckdigit(cusip: tcusip): integer;
    (* Check digit *)
  var
    i, sum, v: integer;
    c: char;
    contcheck: boolean; (* Continue checking? *)
  begin
    i := 1;
    sum := 0;
    contcheck := true;
    while (i <= cusiplen) and contcheck do
    begin
      c := cusip[i];
      if ('0' <= c) and (c <= '9') then v := ord(c) - 48
      else if ('A' <= c) and (c <= 'Z') then v := ord(c) - 65 + 10
      else if c = '*' then v := 36
      else if c = '@' then v := 37
      else if c = '#' then v := 38
      else
      begin
        cusipcheckdigit := -1;
        contcheck := false;
      end;
      if contcheck then
      begin
        if (i - 1) mod 2 = 1 then v := 2 * v;
        if i <= 8 then sum := sum + (v div 10) + (v mod 10);
        i := i + 1;
      end;
    end;
    if contcheck then
      if i <> 10 then cusipcheckdigit := -1
      else cusipcheckdigit := (10 - (sum mod 10)) mod 10;
  end;

  function isvalidcusip(cusip: tcusip): boolean;
  var
    check: integer;
  begin
    check := cusipcheckdigit(cusip);
    if check < 0 then isvalidcusip := false
    else isvalidcusip := (ord(cusip[9]) = ord(48 + check));
  end;

  procedure writeverdict(cusip: tcusip);
  (* Write the verdict *)
  begin
    write(cusip);
    if isvalidcusip(cusip) then writeln(' : Valid')
    else writeln(' : Invalid');
  end;

begin
  writeln('CUSIP       Verdict');
  writeverdict('037833100');
  writeverdict('17275R102');
  writeverdict('38259P508');
  writeverdict('594918104');
  writeverdict('68389X106');
  writeverdict('68389X105');
  (* readln; *)
end.
