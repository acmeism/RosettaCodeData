MODULE PQueues;
IMPORT StdLog,Boxes;

TYPE
  Rank* = POINTER TO RECORD
    p-: LONGINT; (* Priority *)
    value-: Boxes.Object
  END;

  PQueue* = POINTER TO RECORD
    a: POINTER TO ARRAY OF Rank;
    size-: LONGINT;
  END;

  PROCEDURE NewRank*(p: LONGINT; v: Boxes.Object): Rank;
  VAR
    r: Rank;
  BEGIN
    NEW(r);r.p := p;r.value := v;
    RETURN r
  END NewRank;

  PROCEDURE NewPQueue*(cap: LONGINT): PQueue;
  VAR
    pq: PQueue;
  BEGIN
    NEW(pq);pq.size := 0;
    NEW(pq.a,cap);pq.a[0] := NewRank(MIN(INTEGER),NIL);
    RETURN pq
  END NewPQueue;

  PROCEDURE (pq: PQueue) Push*(r:Rank), NEW;
  VAR
    i: LONGINT;
  BEGIN
    INC(pq.size);
    i := pq.size;
    WHILE r.p < pq.a[i DIV 2].p DO
      pq.a[i] := pq.a[i DIV 2];i := i DIV 2
    END;
    pq.a[i] := r
  END Push;

  PROCEDURE (pq: PQueue) Pop*(): Rank,NEW;
  VAR
    r,y: Rank;
    i,j: LONGINT;
    ok: BOOLEAN;
  BEGIN
    r := pq.a[1]; (* Priority object *)
    y := pq.a[pq.size]; DEC(pq.size); i := 1; ok := FALSE;
    WHILE (i <= pq.size DIV 2) & ~ok DO
      j := i + 1;
      IF (j < pq.size) & (pq.a[i].p > pq.a[j + 1].p) THEN INC(j) END;
      IF y.p > pq.a[j].p THEN pq.a[i] := pq.a[j]; i := j ELSE ok := TRUE END
    END;
    pq.a[i] := y;
    RETURN r
  END Pop;

  PROCEDURE (pq: PQueue) IsEmpty*(): BOOLEAN,NEW;
  BEGIN
    RETURN pq.size = 0
  END IsEmpty;

  PROCEDURE Test*;
  VAR
    pq: PQueue;
    r: Rank;
    PROCEDURE ShowRank(r:Rank);
    BEGIN
      StdLog.Int(r.p);StdLog.String(":> ");StdLog.String(r.value.AsString());StdLog.Ln;
    END ShowRank;
  BEGIN
    pq := NewPQueue(128);
    pq.Push(NewRank(3,Boxes.NewString("Clear drains")));
    pq.Push(NewRank(4,Boxes.NewString("Feed cat")));
    pq.Push(NewRank(5,Boxes.NewString("Make tea")));
    pq.Push(NewRank(1,Boxes.NewString("Solve RC tasks")));
    pq.Push(NewRank(2,Boxes.NewString("Tax return")));
    ShowRank(pq.Pop());
    ShowRank(pq.Pop());
    ShowRank(pq.Pop());
    ShowRank(pq.Pop());
    ShowRank(pq.Pop());
  END Test;

END PQueues.
