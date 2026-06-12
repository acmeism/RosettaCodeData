my ($rows,$cols) = qx/stty size/.words;
my $v = floor $rows / 2;
print "\e[H\e[J", 'Generating sine wave of zero amplitude and zero frequency for 5 seconds...',
  "\e[$v;0H", '_' x $cols;
sleep 5;
say "\e[H\e[J", 'No?, ok how about this:';

use SVG;
my $filename = 'sine.svg';
my $out = open($filename, :w) orelse .die;
$out.say: SVG.serialize(
    svg => [
        width => 400, height => 150, style => 'stroke:rgb(0,0,255)',
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :path[ :fill<none>, :d('M0,25 C36.42,25,63.58,125,100,125 M100,125 C136.42,125,163.58,25,200,25 M200,25 C236.42,25,263.58,125,300,125 M300,125 C336.42,125,363.58,25,400,25') ],
    ],
);
close $out;
say "Sine wave generated to {$filename.IO.absolute}, better open it quickly...";
sleep 5;
unlink $filename;
say 'Oops, too late.';
say 'Still no? Ok how about:';
shell 'play -n -c1 synth 5.0 sin %-12';
