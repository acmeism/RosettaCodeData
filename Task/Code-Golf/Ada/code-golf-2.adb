with Ada.Text_IO;procedure C is L:array(1 .. 9)of Integer:=(67,111,100,101,32,71,111,108,102);begin for C of L loop Ada.Text_IO.Put(Character'Val(C));end loop;end;
