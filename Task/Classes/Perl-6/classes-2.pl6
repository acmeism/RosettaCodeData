class Butterfly {
    has Int $!age;    # The ! twigil makes it private.
    has Str $.name;
    has Str $.color;
    has Bool $.wings;

    submethod BUILD(:$!name = 'Camelia', :$!age = 2, :$!color = 'pink') {
        # BUILD is called by bless. Its primary use is to to control
        # object initialization.
        $!wings = $!age > 1;
    }

    method flap() {
        say ($.wings
          ?? 'Watch out for that hurricane!'
          !! 'No wings to flap.');
    }
}

my Butterfly $a .= new: age => 5;
say "Name: {$a.name}, Color: {$a.color}";
$a.flap;

my Butterfly $b .= new(name => 'Osgood', age => 4);
say "Name: {$b.name}, Color: {$b.color}";
$b.flap;
