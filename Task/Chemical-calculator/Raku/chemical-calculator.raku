my %ATOMIC_MASS =
    H  =>   1.008       , Fe =>  55.845    , Te => 127.60       , Ir => 192.217    ,
    He =>   4.002602    , Co =>  58.933194 , I  => 126.90447    , Pt => 195.084    ,
    Li =>   6.94        , Ni =>  58.6934   , Xe => 131.293      , Au => 196.966569 ,
    Be =>   9.0121831   , Cu =>  63.546    , Cs => 132.90545196 , Hg => 200.592    ,
    B  =>  10.81        , Zn =>  65.38     , Ba => 137.327      , Tl => 204.38     ,
    C  =>  12.011       , Ga =>  69.723    , La => 138.90547    , Pb => 207.2      ,
    N  =>  14.007       , Ge =>  72.630    , Ce => 140.116      , Bi => 208.98040  ,
    O  =>  15.999       , As =>  74.921595 , Pr => 140.90766    , Po => 209        ,
    F  =>  18.998403163 , Se =>  78.971    , Nd => 144.242      , At => 210        ,
    Ne =>  20.1797      , Br =>  79.904    , Pm => 145          , Rn => 222        ,
    Na =>  22.98976928  , Kr =>  83.798    , Sm => 150.36       , Fr => 223        ,
    Mg =>  24.305       , Rb =>  85.4678   , Eu => 151.964      , Ra => 226        ,
    Al =>  26.9815385   , Sr =>  87.62     , Gd => 157.25       , Ac => 227        ,
    Si =>  28.085       , Y  =>  88.90584  , Tb => 158.92535    , Th => 232.0377   ,
    P  =>  30.973761998 , Zr =>  91.224    , Dy => 162.500      , Pa => 231.03588  ,
    S  =>  32.06        , Nb =>  92.90637  , Ho => 164.93033    , U  => 238.02891  ,
    Cl =>  35.45        , Mo =>  95.95     , Er => 167.259      , Np => 237        ,
    Ar =>  39.948       , Ru => 101.07     , Tm => 168.93422    , Pu => 244        ,
    K  =>  39.0983      , Rh => 102.90550  , Yb => 173.054      , Am => 243        ,
    Ca =>  40.078       , Pd => 106.42     , Lu => 174.9668     , Cm => 247        ,
    Sc =>  44.955908    , Ag => 107.8682   , Hf => 178.49       , Bk => 247        ,
    Ti =>  47.867       , Cd => 112.414    , Ta => 180.94788    , Cf => 251        ,
    V  =>  50.9415      , In => 114.818    , W  => 183.84       , Es => 252        ,
    Cr =>  51.9961      , Sn => 118.710    , Re => 186.207      , Fm => 257        ,
    Mn =>  54.938044    , Sb => 121.760    , Os => 190.23       ,
;
grammar Chemical_formula {
    my @ATOMIC_SYMBOLS = %ATOMIC_MASS.keys.sort;

    rule  TOP      { ^ (<lparen>|<rparen>|<element>)+ $ }
    token quantity { \d+ }
    token lparen   { '(' }
    token rparen   { ')'                    <quantity>? }
    token element  { $<e>=[@ATOMIC_SYMBOLS] <quantity>? }
}
class Chemical_formula_actions {
    has @stack = 0;
    method TOP     ($/) { $/.make: @stack }
    method lparen  ($/) { push @stack, 0  }
    method rparen  ($/) { my $m = @stack.pop;
                          @stack[*-1] += ($<quantity> // 1) * $m }
    method element ($/) { @stack[*-1] += ($<quantity> // 1) * %ATOMIC_MASS{~$<e>} }
}
sub molar_mass ( Str $formula --> Real ) {
    Chemical_formula.parse( $formula, :actions(Chemical_formula_actions.new) )
        orelse die "Chemical formula not recognized: '$formula'";
    return $/.made.[0];
}
say .&molar_mass.fmt('%7.3f '), $_ for <H H2 H2O Na2SO4 C6H12 COOH(C(CH3)2)3CH3>;
