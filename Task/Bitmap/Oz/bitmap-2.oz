%% For real task prefer QTk's images:
%% http://www.mozart-oz.org/home/doc/mozart-stdlib/wp/qtk/html/node38.html

functor
import
   Array2D
export
   New
   Fill
   GetPixel
   SetPixel
define
   Black = color(0x00 0x00 0x00)

   fun {New Width Height}
      bitmap( {Array2D.new Width Height Black} )
   end

   proc {Fill bitmap(Arr) Color}
      {Array2D.transform Arr fun {$ _} Color end}
   end

   fun {GetPixel bitmap(Arr) X Y}
      {Array2D.get Arr X Y}
   end

   proc {SetPixel bitmap(Arr) X Y Color}
      {Array2D.set Arr X Y Color}
   end

   %% Omitted: MaxValue, ForAllPixels, Transform
end
