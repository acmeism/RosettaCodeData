# 20250718 Raku programming solution

class Tamagotchi {
   has Str $.name;
   has Int $.age is rw = 0;
   has Int $.bored is rw = 0;
   has Int $.food is rw = 2;
   has Int $.poop is rw = 0;
}

my Tamagotchi $tama;

my @verbs = < Ask Ban Bash Bite Break Build Cut Dig Drag Drop Drink Enjoy
              Eat End Feed Fill Force Grasp Gas Get Grab Grip Hoist House
              Ice Ink Join Kick Leave Marry Mix Nab Nail Open Press Quash
              Rub Run Save Snap Taste Touch Use Vet View Wash Xerox Yield >;

my @nouns = < arms bugs boots bowls cabins cigars dogs eggs fakes flags
              greens guests hens hogs items jowls jewels juices kits logs
              lamps lions levers lemons maps mugs names nests nights nurses
              orbs owls pages posts quests quotas rats ribs roots rules
              salads sauces toys urns vines words waters zebras >;

my @bored-icons = '💤', '💭', '❓';
my @food-icons  = '🍼', '🍔', '🍟', '🍰', '🍜';
my @poop-icons  = '💩';
my @sick-icons1 = '😄', '😃', '😀', '😊', '😎', '👍';  # ok
my @sick-icons2 = '😪', '😥', '😰', '😓';              # ailing
my @sick-icons3 = '😩', '😫';                          # bad
my @sick-icons4 = '😡', '😱';                          # very bad
my @sick-icons5 = '❌', '💀', '👽', '😇';              # dead


sub brace(@runes) returns Str { return "{ " ~ @runes.join('') ~ " }" }

sub create(Str $name) { $tama = Tamagotchi.new(:name($name)) }

sub alive() returns Bool { return sickness() <= 10 }

sub feed() { $tama.food++ }

sub play() { $tama.bored = max(0, $tama.bored - (0..1).pick) }

sub talk() {
   my $verb = @verbs.pick;
   my $noun = @nouns.pick;
   say "😮 : $verb the $noun.";
   $tama.bored = max(0, $tama.bored - 1);
}

sub clean() { $tama.poop = max(0, $tama.poop - 1) }

sub wait() {
   $tama.age++;
   $tama.bored += (0..1).pick;
   $tama.food   = max(0, $tama.food - 2);
   $tama.poop  += (0..1).pick;
}

sub status() returns Str {
   if alive() {
      my @b = $tama.bored == 0 ?? () !! (@bored-icons.pick xx $tama.bored);
      my @f = $tama.food  == 0 ?? () !! (@food-icons.pick xx $tama.food);
      my @p = $tama.poop  == 0 ?? () !! (@poop-icons.pick xx $tama.poop);
      return brace(@b) ~ "  " ~ brace(@f) ~ "  " ~ brace(@p);
   }
   return " R.I.P";
}

sub sickness() returns Int { # dies at age 42 at the latest
   return $tama.poop+$tama.bored+max(0, $tama.age - 32)+abs($tama.food - 2)
}

sub health() {
   my $s = sickness();
   my $icon = do given $s {
      when 0..2  { @sick-icons1.pick }
      when 3..4  { @sick-icons2.pick }
      when 5..6  { @sick-icons3.pick }
      when 7..10 { @sick-icons4.pick }
      default    { @sick-icons5.pick }
   };
   say "$tama.name() (🎂 $tama.age())  $icon $s  " ~ status() ~"\n";
}

sub blurb() {
   say "When the '?' prompt appears, enter an action optionally";
   say "followed by the number of repetitions from 1 to 9.";
   say "If no repetitions are specified, one will be assumed.";
   say "The available options are: feed, play, talk, clean or wait.";
   say "";
}

sub MAIN() {
   say "         TAMAGOTCHI EMULATOR";
   say "         ===================";
   say "";

   print "Enter the name of your tamagotchi : ";
   my $name = $*IN.get.trim.lc;
   create($name);

   say "";
   printf "%*s (age) health \{bored\} \{food\}  \{poop\}\n", -$name.chars, "name";
   say "";

   health();
   blurb();

   my $count = 0;

   while alive() {
      my $input = prompt "? ";
      my @items = $input.split(/\s+/);

      next if @items.elems > 2;

      my $action = @items[0].lc;
      next unless $action ~~ any(<feed play talk clean wait>);

      my $reps = 1;
      if @items.elems == 2 { $reps = @items[1].Int or next }

      for ^$reps {
         given $action {
             when 'feed'  { feed() }
             when 'play'  { play() }
             when 'talk'  { talk() }
             when 'clean' { clean() }
             when 'wait'  { wait() }
         }
         if $action ne 'wait' { # simulate wait on every third (non-wait) action
            $count++;
            if $count %% 3 { wait() }
         }
      }
      health();
   }
}
