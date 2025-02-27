uses System, System.Threading, System.Threading.Tasks;

procedure Worker(arg: SemaphoreSlim; id: integer);
begin
  var sem: SemaphoreSlim := arg;
  sem.Wait();
  Writeln('Thread ', id, ' has a semaphore & is now working.');
  Thread.Sleep(2 * 1000);
  Writeln('#', id, 'done.');
  sem.Release();
end;

begin
  var semaphore := new SemaphoreSlim(Environment.ProcessorCount * 2, MaxInt);

  Writeln('You have ', Environment.ProcessorCount, ' processors availiabe');
  Writeln('This program will use ', semaphore.CurrentCount, ' semaphores.');

  Parallel.For(0, Environment.ProcessorCount * 3, y -> Worker(semaphore, y));
end.
