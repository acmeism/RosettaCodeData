my %scale =
    Celcius    => { factor => 1  , offset => -273.15 },
    Rankine    => { factor => 1.8, offset =>    0    },
    Fahrenheit => { factor => 1.8, offset => -459.67 },
;

my $kelvin = +prompt "Enter a temperature in Kelvin: ";
die "No such temperature!" if $kelvin < 0;

for %scale.sort {
    printf "%12s: %7.2f\n", .key, $kelvin * .value<factor> + .value<offset>;
}
