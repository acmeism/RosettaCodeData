with Interfaces;

package Population_Count is
   subtype Num is Interfaces.Unsigned_64;
   function Pop_Count(N: Num) return Natural;
end Population_Count;
