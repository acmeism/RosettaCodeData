unit:(::)
bind:{[k;a]:[a~`N;a;k a]}
kcomp:{[f;g](bind[g;]@f@)} / (>=>) i.e. kleisli composition
