# 20201201 added Perl programming solution

use strict;
use warnings;

package MessageMultiplier;

use Class::Contract;
use Test::More tests => 2;
use Test::Exception;

contract {

   attr 'multiplier' => 'SCALAR';
   attr 'message'    => 'SCALAR';

   ctor 'new';
      impl { ( ${self->multiplier}, ${self->message} ) = @_ };

   method 'execute';
      pre  { ${self->multiplier} > 1 and length ${self->message} > 0 };
      impl { print ${self->message} x ${self->multiplier} , "\n" };
};

MessageMultiplier->new(2,'A')->execute;
dies_ok { MessageMultiplier->new(1,'B')->execute };
dies_ok { MessageMultiplier->new(3, '')->execute };
