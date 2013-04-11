program matmultSUMMA;

prototype GetSingleDim(infile:file):integer;
prototype GetInnerDim(infile1:file; infile2:file):integer;

config var
          Afilename: string = "";
          Bfilename: string = "";

          Afile: file = open(Afilename,file_read);
          Bfile: file = open(Bfilename,file_read);

          default_size:integer = 4;
          m:integer = GetSingleDim(Afile);
          n:integer = GetInnerDim(Afile,Bfile);
          p:integer = GetSingleDim(Bfile);

          iters: integer = 1;

          printinput: boolean = false;
          verbose: boolean = true;
          dotiming: boolean = false;

region
       RA = [1..m,1..n];
       RB = [1..n,1..p];
       RC = [1..m,1..p];
       FCol = [1..m,*];
       FRow = [*,1..p];

var
    A : [RA] double;
    B : [RB] double;
    C : [RC] double;
    Aflood : [FCol] double;
    Bflood : [FRow] double;


procedure ReadA();
var step:double;
[RA] begin
       if (Afile != znull) then
         read(Afile,A);
       else
         step := 1.0/(m*n);
         A := ((Index1-1)*n + Index2)*step + 1.0;
       end;
     end;


procedure ReadB();
var step:double;
[RB] begin
       if (Bfile != znull) then
         read(Bfile,B);
       else
         step := 1.0/(n*p);
         B := ((Index1-1)*p + Index2)*step + 1.0;
       end;
     end;


procedure matmultSUMMA();
var
    i: integer;
    it: integer;
    runtime: double;
[RC] begin
       ReadA();
       ReadB();

       if (printinput) then
         [RA] writeln("A is:\n",A);
         [RB] writeln("B is:\n",B);
       end;

       ResetTimer();

       for it := 1 to iters do

         C := 0.0;                       -- zero C

         for i := 1 to n do
           [FCol] Aflood := >>[,i] A;       -- flood A col
           [FRow] Bflood := >>[i,] B;       -- flood B row

           C += (Aflood * Bflood);   -- multiply
         end;
       end;

       runtime := CheckTimer();

       if (verbose) then
         writeln("C is:\n",C);
       end;

       if (dotiming) then
         writeln("total runtime  = %12.6f":runtime);
         writeln("actual runtime = %12.6f":runtime/iters);
       end;
     end;


procedure GetSingleDim(infile:file):integer;
var dim:integer;
begin
  if (infile != znull) then
    read(infile,dim);
  else
    dim := default_size;
  end;
  return dim;
end;


procedure GetInnerDim(infile1:file; infile2:file):integer;
var
   col:integer;
   row:integer;
   retval:integer;
begin
  retval := -1;
  if (infile1 != znull) then
    read(infile1,col);
    retval := col;
  end;
  if (infile2 != znull) then
    read(infile2,row);
    if (retval = -1) then
      retval := row;
    else
      if (row != col) then
        halt("ERROR: Inner dimensions don't match");
      end;
    end;
  end;
  if (retval = -1) then
    retval := default_size;
  end;
  return retval;
end;
