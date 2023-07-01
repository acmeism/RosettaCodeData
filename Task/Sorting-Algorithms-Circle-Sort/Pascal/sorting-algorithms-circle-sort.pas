{
   source file name on linux is ./p.p

   -*- mode: compilation; default-directory: "/tmp/" -*-
   Compilation started at Sat Mar 11 23:55:25

   a=./p && pc $a.p && $a
   Free Pascal Compiler version 3.0.0+dfsg-8 [2016/09/03] for x86_64
   Copyright (c) 1993-2015 by Florian Klaempfl and others
   Target OS: Linux for x86-64
   Compiling ./p.p
   Linking p
   /usr/bin/ld.bfd: warning: link.res contains output sections; did you forget -T?
   56 lines compiled, 0.0 sec
   1 2 3 4 5 6 7 8 9

   Compilation finished at Sat Mar 11 23:55:25
}

program sort;

var
   a : array[0..999] of integer;
   i :  integer;

procedure circle_sort(var a : array of integer; left : integer; right : integer);
var swaps : integer;

   procedure csinternal(var a : array of integer; left : integer; right : integer; var swaps : integer);
   var
      lo, hi, mid : integer;
      t           : integer;
   begin
      if left < right then
      begin
	 lo := left;
	 hi := right;
	 while lo < hi do
	 begin
	    if a[hi] < a[lo] then
	    begin
	       t := a[lo]; a[lo] := a[hi]; a[hi] := t;
	       swaps := swaps + 1;
	    end;
	    lo := lo + 1;
	    hi := hi - 1;
	 end;
	 if (lo = hi) and (a[lo+1] < a[lo]) then
	 begin
	    t := a[lo]; a[lo] := a[lo+1]; a[lo+1] := t;
	    swaps := swaps + 1;
	 end;
	 mid := trunc((hi + lo) / 2);
	 csinternal(a, left, mid, swaps);
	 csinternal(a, mid + 1, right, swaps)
      end
   end;

begin;
   swaps := 1;
   while (0 < swaps) do
   begin
      swaps := 0;
      csinternal(a, left, right, swaps);
   end
end;

begin
   {
      generating polynomial coefficients computed in j:  6 7 8 9 2 5 3 4 1x %. ^/~i.9x
      are 6 29999r280 _292519r1120 70219r288 _73271r640 10697r360 _4153r960 667r2016 _139r13440
   }
   a[1]:=6;a[2]:=7;a[3]:=8;a[4]:=9;a[5]:=2;a[6]:=5;a[7]:=3;a[8]:=4;a[9]:=1;
   circle_sort(a,1,9);
   for i := 1 to 9 do write(a[i], ' ');
   writeln();
end.
