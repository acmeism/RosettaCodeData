# 20240622 Raku programming solution

grammar SRT { # loc.gov/preservation/digital/formats/fdd/fdd000569.shtml
   token TOP { ^ <subtitle>+ % \n $ }
   token subtitle { <index> \n <timecode> \n <text> \n? }
   token index { \d+ }
   token timecode { <timestamp> ' --> ' <timestamp> }
   token timestamp { \d ** 2 ':' \d ** 2 ':' \d ** 2 ',' \d ** 3 }
   token text { <line>+ % \n }
   token line { <-[\n]>+ }
}

class SRT::Actions { has @.subtitles;

   method TOP($/) {
      @.subtitles = $<subtitle>».made;
      make @.subtitles
   }

   method subtitle($/) {
      make {
         index => $<index>.Str,
         start => $<timecode><timestamp>[0].made,
         end   => $<timecode><timestamp>[1].made,
         text  => $<text>.made,
      }
   }

   method timestamp($/) { make $/.Str }

   method text($/) { make $<line>.join("\n") }
}

class SubtitleAdjuster {

    method adjust-time($time, $seconds) {
       my ($time-str, $milliseconds-str) = $time.split(',');
       my (\hh, \mm, \ss) = $time-str.split(':')>>.Int;
       my \mls            = $milliseconds-str.Int;
       my $datetime = DateTime.new( :year, :month, :day,
                                    :hour(hh), :minute(mm), :second(ss));
       given $datetime .= later(:seconds($seconds)) {
          return sprintf('%02d:%02d:%02d,%03d', .hour, .minute, .second, mls)
       }
   }

   method adjust-subtitles(@subtitles, Int $seconds) {
      @subtitles.map({
         $_<start> = self.adjust-time($_<start>, $seconds);
         $_<end>   = self.adjust-time($_<end>, $seconds);
         $_;
      });
   }

   method format-srt(@subtitles) {
      @subtitles.map({
         $_<index> ~ "\n"
         ~ $_<start> ~ " --> " ~ $_<end> ~ "\n"
         ~ $_<text> ~ "\n"
      }).join("\n");
   }
}

my $srt-content = $*IN.slurp;
my $parsed = SRT.parse($srt-content, :actions(SRT::Actions.new));
my @subtitles = $parsed.made;

my $adjuster = SubtitleAdjuster.new;

for 9, -9 -> \N {
   my @adjusted-subtitles = $adjuster.adjust-subtitles(@subtitles.deepmap(*.clone), N);
   say "Original subtitle adjusted by {N.fmt('%+d')} seconds.";
   say $adjuster.format-srt(@adjusted-subtitles);
}
