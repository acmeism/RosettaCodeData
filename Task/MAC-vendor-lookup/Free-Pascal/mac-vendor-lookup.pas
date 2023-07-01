program MACVendorLookup;

uses
  fphttpclient;

var
  res: String;
begin
  if paramCount > 0 then begin

    With TFPHttpClient.Create(Nil) do
    try
      allowRedirect := true;
      try
        res := Get('http://api.macvendors.com/' + ParamStr(1));
        writeLn(res);
      except
        writeLn('N/A');
      end;
    finally
      Free;
    end;
  end;
end.
