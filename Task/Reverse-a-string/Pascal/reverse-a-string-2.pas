{Copy and paste it in your program}
function revstr(my_s:string):string;
    var out_s:string;
    ls,i:integer;
    begin
    ls:=length(my_s);
    for i:=1 to ls do
    out_s:=out_s+my_s[ls-i+1];
    revstr:=out_s;
    end;
