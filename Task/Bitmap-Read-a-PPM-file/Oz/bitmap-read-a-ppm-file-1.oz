functor
import
   Bitmap
   Open
export
   Read
   %% Write
define
   fun {Read Filename}
      F = {New Open.file init(name:Filename)}

      fun {ReadColor8 _}
	 Bytes = {F read(list:$ size:3)}
      in
	 {List.toTuple color Bytes}
      end

      fun {ReadColor16 _}
	 Bytes = {F read(list:$ size:6)}
      in
	 {List.toTuple color {Map {PairUp Bytes} FromBytes}}
      end
   in
      try
	 Magic = {F read(size:2 list:$)}
	 if Magic \= "P6" then raise bitmapIO(read unsupportedFormat(Magic)) end end
	 Width = {ReadNumber F}
	 Height = {ReadNumber F}
	 MaxVal = {ReadNumber F}
	 MaxVal =< 0xffff = true
	 Reader = if MaxVal =< 0xff then ReadColor8 else ReadColor16 end
	 B = {Bitmap.new Width Height}
      in
	 {Bitmap.transform B Reader}
	 B
      finally
	 {F close}
      end
   end

   fun {ReadNumber F}
      Ds
   in
      {SkipWS F}
      Ds = for collect:Collect break:Break do
	      [C] = {F read(list:$ size:1)}
	   in
	      if {Char.isDigit C} then {Collect C}
	      else {Break}
	      end
	   end
      {SkipWS F}
      {String.toInt Ds}
   end

   proc {SkipWS F}
      [C] = {F read(list:$ size:1)}
   in
      if {Char.isSpace C} then {SkipWS F}
      elseif C == &# then
	 {SkipLine F}
      else
	 {F seek(whence:current offset:~1)}
      end
   end

   proc {SkipLine F}
      [C] = {F read(list:$ size:1)}
   in
      if C \= &\n andthen  C \= &\r then {SkipLine F} end
   end

   fun {PairUp Xs}
      case Xs of X1|X2|Xr then [X1 X2]|{PairUp Xr}
      [] nil then nil
      end
   end

   fun {FromBytes [C1 C2]}
      C1 * 0x100 + C2
   end

   %% Omitted: Write
end
