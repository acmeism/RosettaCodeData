DEFINITION PQueues;

  IMPORT Boxes;

  TYPE
    PQueue = POINTER TO RECORD
      size-: LONGINT;
      (pq: PQueue) IsEmpty (): BOOLEAN, NEW;
      (pq: PQueue) Pop (): Rank, NEW;
      (pq: PQueue) Push (r: Rank), NEW
    END;

    Rank = POINTER TO RECORD
      p-: LONGINT;
      value-: Boxes.Object
    END;

  PROCEDURE NewPQueue (cap: LONGINT): PQueue;
  PROCEDURE NewRank (p: LONGINT; v: Boxes.Object): Rank;
  PROCEDURE Test;

END PQueues.
