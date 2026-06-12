with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
procedure SubsetSum is
   function "+"(S:String) return Unbounded_String renames To_Unbounded_String;
   type Point is record
      str : Unbounded_String;
      num : Integer;
   end record;
   type Points is array (Natural range <>) of Point;
   type Indices is array (Natural range <>) of Natural;

   procedure Print (data : Points; list : Indices; len : Positive) is begin
      Put (len'Img & ":");
      for i in 0..len-1 loop
         Put (" "& To_String(data(list(i)).str));
      end loop; New_Line;
   end Print;

   function Check (data : Points; list : Indices; len : Positive) return Boolean is
      sum : Integer := 0;
   begin
      for i in 0..len-1 loop sum := sum + data(list(i)).num; end loop;
      return sum = 0;
   end Check;

   procedure Next (list : in out Indices; n, r : Positive ) is begin
      for i in reverse 0..r-1 loop
         if list(i)/=i+n-r then list(i):=list(i)+1;
            for j in i+1..r-1 loop list(j):=list(j-1)+1; end loop; exit;
         end if;
      end loop;
   end Next;

   data : constant Points := ((+"alliance", -624), (+"archbishop", -915),
      (+"balm", 397), (+"bonnet", 452), (+"brute", 870),
      (+"centipede", -658), (+"cobol", 362), (+"covariate", 590),
      (+"departure", 952), (+"deploy", 44), (+"diophantine", 645),
      (+"efferent", 54), (+"elysee", -326), (+"eradicate", 376),
      (+"escritoire", 856), (+"exorcism", -983), (+"fiat", 170),
      (+"filmy", -874), (+"flatworm", 503), (+"gestapo", 915),
      (+"infra", -847), (+"isis", -982), (+"lindholm", 999),
      (+"markham", 475), (+"mincemeat", -880), (+"moresby", 756),
      (+"mycenae", 183), (+"plugging", -266), (+"smokescreen", 423),
      (+"speakeasy", -745), (+"vein", 813));
   list, last : Indices (data'Range);
begin
   for len in 2..data'Length loop
      for i in 0..len-1 loop list(i):=i; end loop;
      loop
         if Check(data, list, len) then Print(data, list, len); exit; end if;
         last := list;
         Next(list, data'Length, len);
         exit when last=list;
      end loop;
   end loop;
end SubsetSum;
