program Priority_queue;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, Boost.Generics.Collection;

var
  Queue: TPriorityQueue<String>;

begin
  Queue := TPriorityQueue<String>.Create(['Clear drains', 'Feed cat',
    'Make tea', 'Solve RC tasks', 'Tax return'], [3, 4, 5, 1, 2]);

  while not Queue.IsEmpty do
    with Queue.DequeueEx do
      Writeln(Priority, ', ', value);
end.
