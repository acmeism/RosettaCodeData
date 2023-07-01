# input: an array of decimal integers representing the utf-8 bytes of a Unicode codepoint.
# output: the corresponding decimal number of that codepoint.
def utf8_encode:
   def lpad($width): [(range(0;8)|0), .[]][- $width:];
   def multibyte:  [1,0,       (.[-6: ]|lpad(6))[]];
   def firstOf2:   [1,1,0,     (.[: -6]|lpad(5))[]];
   def firstOf3:   [1,1,1,0,   (.[:-12]|lpad(4))[]];
   def firstOf4:   [1,1,1,1,0, (.[:-18]|lpad(3))[]];
   . as $n
   | binary_digits
   | length as $len
   | if $len <8 then [$n]
     else if   $len <= 12 then [ firstOf2, multibyte ]
          elif $len <= 16 then [ firstOf3, (.[:-6] | multibyte), multibyte ]
          else [firstOf4,
                (.[   :-12] | multibyte),
                (.[-12: -6] | multibyte),
                multibyte]
          end
	  | map(binary_to_decimal)
     end;
