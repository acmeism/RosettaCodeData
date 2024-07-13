uses CRT;

begin
  GotoXY(60,15);
  Sleep(1000);
  GotoXY(WhereX + 1,WhereY);
  Sleep(1000);
  GotoXY(WhereX - 1,WhereY);
  Sleep(1000);
  GotoXY(WhereX,WhereY - 1);
  Sleep(1000);
  GotoXY(WhereX,WhereY + 1);
  Sleep(1000);
  GotoXY(1,WhereY + 1);
  Sleep(1000);
  GotoXY(WindowWidth,WhereY + 1);
  Sleep(1000);
  GotoXY(1,1);
  Sleep(1000);
  GotoXY(WindowWidth,WindowHeight);
  Sleep(10000);
end.
