with Tables;
procedure Table_Test is
   My_Table : Tables.Table;
begin
   ... -- insert stuff in table
   Sort (My_Table); -- use default sorting
   Sort (My_Table, Psionic, 5, True); -- use psionic sorting by 5th column in reverse order
   Sort (It => My_Table, Reverse_Ordering => True); -- use default sorting in reverse order
   ... -- other stuff
end Table_Test;
