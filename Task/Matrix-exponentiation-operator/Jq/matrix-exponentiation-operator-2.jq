def pi: 4 * (1|atan);

def rotation_matrix(theta):
  [[(theta|cos), (theta|sin)], [-(theta|sin), (theta|cos)]];

def demo_matrix_exp(n):
  rotation_matrix( pi / 4 ) | matrix_exp(n) ;

def demo_direct_matrix_exp(n):
  rotation_matrix( pi / 4 ) | direct_matrix_exp(n) ;
