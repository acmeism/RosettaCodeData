with Interfaces.C;          use Interfaces.C;
with Interfaces.C.Strings;  use Interfaces.C.Strings;

package Exported is
   function Query (Data : chars_ptr; Size : access size_t)
      return int;
   pragma Export (C, Query, "Query");
end Exported;
