# 20250715 Raku programming solution

grammar CSV2TSV {
   token TOP            { <field>* % [ <ws> ',' <ws> ] <ws> <nonsense>? \n? }
   token field          { [ <ws> <quoted-field> <ws> ] || <unquoted-field> }
   token quoted-field   { '"' <quoted-content>? '"' }
   token quoted-content { [ '""' || <-["]> ]+ }
   token unquoted-field { <-[,\n"]>* }
   token nonsense       { <-[\n]>* }
   token ws             { ' '* }
}

class CSV2TSV-Actions {
   method TOP($/) {
      my @fields = $<field>>>.made;
      my $csv = $/.Str.trans( < \\ \0 \n \r \b > Z=> < \\\\ \\0 \\n \\r \\b > );
      my $tsv = @fields.Bool ?? @fields.join("\t") !! "";
      make [$csv, $tsv];
   }

   method field($/) {
      make $<quoted-field> ?? $<quoted-field>.made !! $<unquoted-field>.Str
   }

   method quoted-field($/) {
      my $content = $<quoted-content>
                    ?? $<quoted-content>.subst('""', '"', :g).trim
                    !! '';
      my $str = $content.subst("\t", '\t', :g);
      make $str.trans( < \\ \0 \n \r \b > Z=> < \\\\ \\0 \\n \\r \\b > );
   }

   method unquoted-field($/) {
      my $str = $/.Str.subst("\t", '\\\\t', :g);
      make $str.trans( < \\ \0 \n \r \b > Z=> < \\\\ \\0 \\n \\r \\b > );
   }
}

my @inputs = ( # as codepoints
   <97 44 34 98 34>,                         # a,"b"
   <34 97 34 44 34 98 34 34 99 34>,          # "a","b""c"
   < >,                                      # empty line
   <44 97>,                                  # ,a
   <97 44 34>,                               # a,"
   <32 97 32 44 32 34 98 34>,                #  a , "b"
   <34 49 50 34 44 51 52>,                   # "12",34
   <97 92 116 98 44>,                        # a\tb, — escaped t, comma
   <97 92 92 116 98>,                        # a\\tb — double backslash
   <97 92 92 110 92 114 98>,                 # a\\n\\rb — multiple escaped
   <97 0 98>,                                # a\0b — NUL
   <97 92 110 98>,                           # a\nb — escaped newline
   <97 92 92 98>,                            # a\\b — escaped backslash
);

for @inputs.values -> @ord-line {
   my $input-str = @ord-line.join(' ');

   my $parse     = CSV2TSV.parse(@ord-line.chrs, :actions(CSV2TSV-Actions));
   unless $parse { say "IN : $input-str\nParse failed\n" and next }

   my ($csv, $tsv) = $parse.made;
   say "IN : $input-str\nOUT: {$tsv.ords.Str}\n";
   #say "TSV: «$tsv»\n"; # 🙈
}
