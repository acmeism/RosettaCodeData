MODULE UseQueue;
IMPORT
  Queue,
  Boxes,
  StdLog;

PROCEDURE Do*;
VAR
  q: Queue.Instance;
  b: Boxes.Box;
BEGIN
  q := Queue.New(10);
  q.Push(Boxes.NewInteger(1));
  q.Push(Boxes.NewInteger(2));
  q.Push(Boxes.NewInteger(3));
  b := q.Pop();
  b := q.Pop();
  q.Push(Boxes.NewInteger(4));
  b := q.Pop();
  b := q.Pop();
  StdLog.String("Is empty:> ");StdLog.Bool(q.IsEmpty());StdLog.Ln
END Do;
END UseQueue.
