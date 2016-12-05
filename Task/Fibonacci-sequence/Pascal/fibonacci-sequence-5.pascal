function Fibo_BigInt(n: integer): string;  //maXbox
  var tbig1, tbig2, tbig3: TInteger;
  begin
    result:= '0'
    tbig1:= TInteger.create(1);  //temp
    tbig2:= TInteger.create(0);  //result (a)
    tbig3:= Tinteger.create(1);  //b
    for it:= 1 to n do begin
    	tbig1.assign(tbig2)
	   tbig2.assign(tbig3);
	   tbig1.add(tbig3);
	   tbig3.assign(tbig1);
	 end;
    result:= tbig2.toString(false)
    tbig3.free;
    tbig2.free;
    tbig1.free;
  end;
