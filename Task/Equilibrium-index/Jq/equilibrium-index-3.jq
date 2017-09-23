def count(g): reduce g as $i (0; .+1);

# Create an array of length n with "init" elements:
def array(n;init): reduce range(0;n) as $i ([]; . + [0]);

count( array(1e4;0) | equilibrium_indices )
