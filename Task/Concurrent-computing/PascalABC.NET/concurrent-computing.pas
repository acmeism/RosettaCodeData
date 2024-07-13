uses System.Threading.Tasks;

begin
  Task.Run(() -> Print('Enjoy'));
  Task.Run(() -> Print('Rosetta'));
  Task.Run(() -> Print('Code'));
  Sleep(100);
end.
