MODULE RosettaVListsUse;

    IMPORT Out, VLists := RosettaVLists;

    TYPE
        Char = VLists.Element;
        String = VLists.List;
        Log = RECORD (VLists.Out) END; (* Used for outputting in "Exp" *)
        App = RECORD (VLists.Accum) s: String END;

    (* Used for appending in "FoldR" *)
    PROCEDURE (VAR a: App) Do (c: Char);
    BEGIN
        a.s.Cons(c)
    END Do;

    (* Uses "FoldR" to concatenate "f" onto "r". *)
    PROCEDURE Append (IN f: String; VAR r: String);
        VAR a: App;
    BEGIN
        a.s := r; f.FoldR(a); r := a.s
    END Append;

    (* Concatenate "f" onto "r". *)
    PROCEDURE Prefix (f: ARRAY OF CHAR; VAR r: String);
        VAR i: INTEGER;
    BEGIN
        FOR i := LEN(f$) - 1 TO 0 BY -1 DO r.Cons(f[i]) END
    END Prefix;

    PROCEDURE Output (s: String);
        VAR i: INTEGER;
    BEGIN
        FOR i := 0 TO s.length - 1 DO Out.Char(s.Nth(i)) END;
    END Output;

    (* Used for outputting in "Expose" *)
    PROCEDURE (IN o: Log) Char- (c: Char);
    BEGIN
        Out.Char(c)
    END Char;

    PROCEDURE Display (IN name: ARRAY OF CHAR; s: String);
        VAR o: Log;
    BEGIN
        Out.String(name + ' = "'); Output(s);
        Out.String('"; length = '); Out.Int(s.length, 0);
        Out.String('; stored as "'); s.Expose(o); Out.Char('"');
        Out.Ln
    END Display;

    PROCEDURE Use*; (* Examples to demonstrate persistence *)
        VAR nu, no, e, d, b: String;
    BEGIN
        nu.Init; Prefix("numerator", nu); Display("nu", nu);
        no := nu; Display("no", no);
        no.NthCdr(5); Display("no", no);
        Prefix("nomin", no); Display("no", no);
        e := nu; e.Cons('e'); Display("e", e);
        Display("no", no); Display("nu", nu);
        d.Init; Prefix("data", d); Display("d", d);
        b.Init; Prefix("base", b); Display("b", b);
        Append(d, b); Display("d", d); Display("b", b);
    END Use;

END RosettaVListsUse.
