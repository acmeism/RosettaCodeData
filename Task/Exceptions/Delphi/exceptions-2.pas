procedure test2;
begin
  try
    test;
  except
    ShowMessage(Exception(ExceptObject).Message); // Showing exception message
    raise; // Rethrowing
  end;
end;
