function answer = fermiDirac(x)
    k = 8.617343e-5; %Boltazmann's Constant in eV/K
    answer = 1./( 1+exp( (x)/(k*2000) ) ); %Fermi-Dirac distribution with mu = 0 and T = 2000K
end
