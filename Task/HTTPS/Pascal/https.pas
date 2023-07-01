{$mode objfpc}{$H+}
uses fphttpclient;

var
  s: string;
  hc: tfphttpclient;

begin
  hc := tfphttpclient.create(nil);
  try
    s := hc.get('https://www.example.com')
  finally
    hc.free
  end;
  writeln(s)
end.
