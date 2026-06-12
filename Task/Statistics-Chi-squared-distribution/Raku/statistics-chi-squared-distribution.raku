# 20221101 Raku programming solution

use Graphics::PLplot;

sub Γ(\z) { # https://rosettacode.org/wiki/Gamma_function#Raku
    constant g = 9;
    z < .5 ?? π/ sin(π * z) / Γ(1 - z)
           !! sqrt(2*π) * (z + g - 1/2)**(z - 1/2) * exp(-(z + g - 1/2)) *
              [+] < 1.000000000000000174663        5716.400188274341379136
                    -14815.30426768413909044       14291.49277657478554025
                    -6348.160217641458813289       1301.608286058321874105
                    -108.1767053514369634679       2.605696505611755827729
                    -0.7423452510201416151527e-2   0.5384136432509564062961e-7
                    -0.4023533141268236372067e-8 > Z* 1, |map 1/(z + *), 0..*
}

sub χ2(\x,\k) {x>0 && k>0 ?? (x**(k/2 - 1)*exp(-x/2)/(2**(k/2)*Γ(k / 2))) !! 0}

sub Γ_cdf(\k,\x) { x**k * exp(-x) * sum( ^101 .map: { x** $_ / Γ(k+$_+1) } ) }

sub cdf_χ2(\x,\k) { (x <= 0 or k <= 0) ?? 0.0 !!  Γ_cdf(k / 2, x / 2) }

say ' 𝒙          χ² ', [~] (1..5)».&{ "𝒌 = $_" ~ ' ' x 13 };
say '-' x my \width = 93;
for 0..10 -> \x {
   say x.fmt('%2d'), [~] (1…5)».&{χ2(x, $_).fmt: "  %-.{((width-2) div 5)-4}f"}
}

say "\nχ² 𝒙     cdf for χ²   P value (df=3)\n", '-' x 36;
for 2 «**« ^6 -> \p {
   my $cdf = cdf_χ2(p, 3).fmt: '%-.10f';
   say p.fmt('%2d'), "     $cdf   ", (1-$cdf).fmt: '%-.10f'
}

my \airport   = [ <77 23>, <88 12>, <79 21>, <81 19> ];
my \expected  = [ <81.25 18.75> xx 4 ];
my \dtotal    = ( (airport »-« expected)»² »/» expected )».List.flat.sum;

say "\nFor the airport data, diff total is ",dtotal,", χ² is ", χ2(dtotal, 3), ", p value ", cdf_χ2(dtotal, 3);

given Graphics::PLplot.new( device => 'png', file-name => 'output.png' ) {
   .begin;
   .pen-width: 3 ;
   .environment: x-range => [-1.0, 10.0], y-range => [-0.1, 0.5], just => 0 ;
   .label: x-axis => '', y-axis => '', title => 'Chi-squared distribution' ;
   for 0..3 -> \𝒌 {
      .color-index0: 1+2*𝒌;
      .line: (0, .1 … 10).map: -> \𝒙 { ( 𝒙, χ2( 𝒙, 𝒌 ) )».Num };
      .text-viewport: side=>'t', disp=>-𝒌-2, pos=>.5, just=>.5, text=>'k = '~𝒌
   } # plplot.sourceforge.net/docbook-manual/plplot-html-5.15.0/plmtex.html
   .end
}
