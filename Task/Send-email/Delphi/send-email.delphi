procedure SendEmail;
var
  msg: TIdMessage;
  smtp: TIdSMTP;
begin
  smtp := TIdSMTP.Create;
  try
    smtp.Host := 'smtp.server.com';
    smtp.Port := 587;
    smtp.Username := 'login';
    smtp.Password := 'password';
    smtp.AuthType := satNone;
    smtp.Connect;
    msg := TIdMessage.Create(nil);
    try
      with msg.Recipients.Add do begin
        Address := 'doug@gmail.com';
        Name := 'Doug';
      end;
      with msg.Sender do begin
        Address := 'fred@server.com';
        Name := 'Fred';
      end;
      msg.Subject := 'subj';
      msg.Body.Text := 'here goes email message';
      smtp.Send(msg);
    finally
      msg.Free;
    end;
  finally
    smtp.Free;
  end;
end;
