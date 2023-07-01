my class Employee {
   has Str $.name;
   has Rat $.wage;
}

my $boss     = Employee.new( name => "Frank Myers"     , wage => 6755.85 );
my $driver   = Employee.new( name => "Aaron Fast"      , wage => 2530.40 );
my $worker   = Employee.new( name => "John Dude"       , wage => 2200.00 );
my $salesman = Employee.new( name => "Frank Mileeater" , wage => 4590.12 );

my @team = $boss, $driver, $worker, $salesman;

my @orderedByName = @team.sort( *.name )».name;
my @orderedByWage = @team.sort( *.wage )».name;

say "Team ordered by name (ascending order):";
say @orderedByName.join('  ');
say "Team ordered by wage (ascending order):";
say @orderedByWage.join('  ');
