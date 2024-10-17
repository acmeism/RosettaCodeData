var
  MyPoint: TMyPoint;
  Circle: TCircle;
begin
  MyPoint := TMyPoint.Create;
  try
    MyPoint.Print;
    Circle := TCircle.Create;
    try
      Circle.Print;
    finally
      FreeAndNil(Circle);
    end;
  finally
    FreeAndNil(MyPoint);
  end;
end;
