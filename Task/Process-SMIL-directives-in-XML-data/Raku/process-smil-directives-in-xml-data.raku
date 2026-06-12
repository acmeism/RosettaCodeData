use XML::XPath;

my $smil = q:to<DATA>; # cramped verison, modified from task data
<?xml version="1.0" ?> <smil><X3D><Scene><Viewpoint position="0 0 8" orientation="0 0 1 0" /><PointLight color="1 1 1" location="0 2 0" /><Shape><Box size="2 1 2"><animate attributeName="size" from="2 1 2" to="1 2 1" begin="0s" dur="10s" /></Box><Appearance><Material diffuseColor="0.0 0.6 1.0"><animate attributeName="diffuseColor" from="0.0 0.6 1.0" to="1.0 0.4 0.0" begin="0s" dur="10s" /></Material></Appearance></Shape></Scene></X3D></smil>
DATA

class Animatee { has ($.todo, @.from, @.to, $.begin, $.dur) is rw };

my %Parents; # keys store the parent tags that got <animate> child

my $x = XML::XPath.new(xml => $smil) or die;

for @($x.find("//animate")) { # strangely need .List or @ coercion to work
   my $y = .parent.name;
   %Parents{$y}:exists ?? die() !! %Parents{$y} = Animatee.new; # unique only
   for .parent.elements {
      %Parents{$y}.todo  = .attribs<attributeName>;
      %Parents{$y}.from  = .attribs<from>.split(/\s+/);
      %Parents{$y}.to    = .attribs<to>.split(/\s+/);
      %Parents{$y}.begin = .attribs<begin>.match(/\d+/);
      %Parents{$y}.dur   = .attribs<dur>.match(/\d+/);
   }
}

# use regex to strip SMIL tag and create a master template; sub-optimal approach
my $z = XML::XPath.new(xml => $smil.subst(/\<\/?smil\>/,'',:g:ii:ss)) or die;

for 0, 2, 4 -> $t { # task requires 0 & 2 only
   my $clone = $z.clone; # work on a copy
   for %Parents.kv -> $k,$v {
      my @incre = ($v.to »-« $v.from) »/» $v.dur; # increment list
      with $clone.find("//$k") { # moving attribute = @from + @increment*$t
         .attribs{%Parents{$_.name}.todo} = $v.from »+« @incre »*» $t;
         .removeChild($_); #  ditch <animate> and friends
      }
   }
   say "when t = ", $t;
   say $clone.find("/");
}
