# 20240816 Raku programming solution

grammar JSON-Unescape {
   token TOP             { ^ <value> $ }
   token value           { [ <str> | \\ <str=.str_escape> ]* }
   token str             { <-["\\\t\x[0A]]>+ }
   token str_escape      { <["\\/bfnrt]> | 'u' <utf16_codepoint>+ % '\u' }
   token utf16_codepoint { <.xdigit>**4 }
}

class JSON-Unescape-Actions {
   method        TOP($/) { make $<value>.made }
   method        str($/) { make ~$/ }
   method      value($/) { make $<str>».made.join }
   method str_escape($/) {
      make $<utf16_codepoint>.Bool
         ?? utf16.new( $<utf16_codepoint>.map({:16(~$_)}) ).decode()
         !! %(< \\ / b n t f r " > Z=> < \\ / \b \n \t \f \r " >).{~$/}
   }
}

for < abc  a☺c  a\"c \u0061\u0062\u0063 a\\\c   a\u263Ac  a\\\u263Ac
      a\uD834\uDD1Ec a\ud834\udd1ec     a"c     a\\u263   a\\u263Xc
      a\\uDD1Ec      a\\uD834c          a\\uD834\\u263Ac > -> $input {
   printf "%20s => ", $input;
   my $o = JSON-Unescape.parse($input, actions => JSON-Unescape-Actions.new).made;
   fail "Invalid JSON string" unless $o.defined;
   say $o;
   CATCH { default { say "Error: $_" } }
}
