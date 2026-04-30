with Ada.Text_IO;

procedure Value_Capture is

   protected type Fun is -- declaration of the type of a protected object
      entry Init(Index: Natural);
      function Result return Natural;
   private
      N: Natural := 0;
   end Fun;

   protected body Fun is -- the implementation of a protected object
      entry Init(Index: Natural) when N=0 is
      begin -- after N has been set to a nonzero value, it cannot be changed any more
         N := Index;
      end Init;
      function Result return Natural is (N*N);
   end Fun;

   A: array (1 .. 10) of Fun; -- an array holding 10 protected objects

begin
   for I in A'Range loop -- initialize the protected objects
      A(I).Init(I);
   end loop;

   for I in A'First .. A'Last-1 loop -- evaluate the functions, except for the last
      Ada.Text_IO.Put(Integer'Image(A(I).Result));
   end loop;
end Value_Capture;
