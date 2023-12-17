package Animal;
#functions go here...
1;

package Dog;
use Animal;
@ISA = qw( Animal );
#functions go here...
1;

package Cat;
use Animal;
@ISA = qw( Animal );
#functions go here...
1;

package Lab;
use Dog;
@ISA = qw( Dog );
#functions go here...
1;

package Collie;
use Dog;
@ISA = qw( Dog );
#functions go here...
1;

# The same using the [http://search.cpan.org/perldoc?MooseX::Declare MooseX::Declare] module:

use MooseX::Declare;

class Animal {
    # methods go here...
}
class Dog extends Animal {
    # methods go here...
}
class Cat extends Animal {
    # methods go here...
}
class Lab extends Dog {
    # methods go here...
}
class Collie extends Dog {
    # methods go here...
}
