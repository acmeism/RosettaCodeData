MODE RANGE = STRUCT (INT lwb, upb);
OP LWB = (RANGE r) INT: lwb OF r;
OP UPB = (RANGE r) INT: upb OF r;

PROC parse range = (STRING s) RANGE:
  BEGIN
    FILE f; associate(f, LOC STRING := s);
    RANGE r; get(f, (lwb OF r, space, upb OF r));
    close(f);
    r
  END;

PROC put range = (REF FILE f, RANGE r) VOID:
  put(f, (whole(LWB r, 0), "-", whole(UPB r, 0)));

PROC print range = (RANGE r) VOID: put range(stand out, r);

PROC parse ranges = (STRING s) FLEX[]RANGE:
  BEGIN
    FLEX[1:0]RANGE rs;
    INT pos; STRING buf := s;
    WHILE char in string(",", pos, buf) DO
      append(rs, parse range(buf[ : pos-1]));
      buf := buf[pos+1 : ]
    OD;
    IF UPB buf > 1 THEN append(rs, parse range(buf)) FI;
    rs
  END;

PROC put ranges = (REF FILE f, []RANGE rs) VOID:
  FOR i TO UPB rs DO
    IF i > 1 THEN put(f, ",") FI;
    put range(f, rs[i])
  OD;

PROC print ranges = ([]RANGE rs) VOID: put ranges(stand out, rs);

PROC in range = (RANGE r, INT n) BOOL: n >= LWB r AND n <= UPB r;

PROC insert at = (REF FLEX[]RANGE rs, INT pos, RANGE r) VOID:
  BEGIN
    [UPB rs + 1]RANGE tmp;
    tmp[ : pos-1] := rs[ : pos-1];
    tmp[pos+1 : ] := rs[pos : ];
    tmp[pos] := r;
    rs := tmp
  END;

PROC delete at = (REF FLEX[]RANGE rs, INT pos) VOID:
  BEGIN
    [UPB rs - 1]RANGE tmp;
    tmp[ : pos-1] := rs[1 : pos-1];
    tmp[pos : ] := rs[pos+1 : ];
    rs := tmp
  END;

PROC append = (REF FLEX[]RANGE rs, RANGE r) VOID: insert at(rs, UPB rs + 1, r);

INT inside = 1, before = 2, after = 3;
MODE POSITION = STRUCT (INT pos, rel);
PROC pos = (POSITION p) INT: pos OF p;
PROC rel = (POSITION p) INT: rel OF p;

PROC index = ([]RANGE rs, INT n) POSITION:
  BEGIN
    POSITION res;
    FOR i TO UPB rs DO
      IF in range(rs[i], n) THEN res := (i, inside); return FI;
      IF n < LWB rs[i] THEN res := (i, before); return FI
    OD;
    res := (UPB rs, after);
    return: res
  END;

PROC add to ranges = (REF FLEX[]RANGE rs, INT n) VOID:
  BEGIN
    POSITION p := index(rs, n);
    INT idx = pos(p);
    IF rel(p) = before THEN
      RANGE r := rs[idx];
      IF LWB r = n + 1 THEN
        r := rs[idx] := (n, UPB r)
      ELSE
        r := (n, n);
        insert at(rs, idx, r)
      FI;
      IF idx > 1 THEN
        IF UPB rs[idx-1] = LWB r - 1 THEN
          rs[idx-1] := (LWB rs[idx-1], UPB r);
          delete at(rs, idx)
        FI
      FI
    ELIF rel(p) = after THEN
      IF IF UPB rs >= 1 THEN UPB rs[UPB rs] = n - 1 ELSE FALSE FI THEN
        rs[UPB rs] := (LWB rs[UPB rs], n)
      ELSE
        append(rs, (n, n))
      FI
    FI
  END;

PROC remove from ranges = (REF FLEX[]RANGE rs, INT n) VOID:
  BEGIN
    POSITION p := index(rs, n);
    INT idx = pos(p);
    IF rel(p) = inside THEN
      RANGE r = rs[idx];
      IF n = LWB r AND n = UPB r THEN
        delete at(rs, idx)
      ELIF n = LWB r THEN
        rs[idx] := (n+1, UPB r)
      ELIF n = UPB r THEN
        rs[idx] := (LWB r, n-1)
      ELSE
        RANGE first  = (LWB r, n-1),
              second = (n+1, UPB r);
        rs[idx] := second;
        insert at(rs, idx, first)
      FI
    FI
  END;

FLEX[1:0]RANGE rs;

PROC start = (STRING s) VOID:
  BEGIN
    rs := parse ranges(s);
    print(" Start: "); print ranges(rs); print(new line)
  END;
PROC add = (INT n) VOID:
  BEGIN
    print(("   add: ", whole(n, 0), ": "));
    add to ranges(rs, n);
    print ranges(rs); print(new line)
  END;
PROC remove = (INT n) VOID:
  BEGIN
    print(("remove: ", whole(n, 0), ": "));
    remove from ranges(rs, n);
    print ranges(rs); print(new line)
  END;

start("");
add(77);
add(79);
add(78);
remove(77);
remove(78);
remove(79);
print(new line);

start("1-3,5-5");
add(1);
remove(4);
add(7);
add(8);
add(6);
remove(7);
print(new line);

start("1-5,10-25,27-30");
add(26);
add(9);
add(7);
remove(26);
remove(9);
remove(7)
