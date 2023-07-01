use 5.020;
use feature qw<signatures>;
no warnings qw<experimental::signatures>;

use constant zero  => sub ($f) {
                      sub ($x) { $x }};

use constant succ  => sub ($n) {
                      sub ($f) {
                      sub ($x) { $f->($n->($f)($x)) }}};

use constant add   => sub ($n) {
                      sub ($m) {
                      sub ($f) {
                      sub ($x) { $m->($f)($n->($f)($x)) }}}};

use constant mult  => sub ($n) {
                      sub ($m) {
                      sub ($f) {
                      sub ($x) { $m->($n->($f))($x) }}}};

use constant power => sub ($b) {
                      sub ($e) { $e->($b) }};

use constant countup   => sub ($i) { $i + 1 };
use constant countdown => sub ($i) { $i == 0 ? zero : succ->( __SUB__->($i - 1) ) };
use constant to_int    => sub ($f) { $f->(countup)->(0) };
use constant from_int  => sub ($x) { countdown->($x) };

use constant three => succ->(succ->(succ->(zero)));
use constant four  => from_int->(4);

say join ' ', map { to_int->($_) } (
    add  ->( three )->( four  ),
    mult ->( three )->( four  ),
    power->( four  )->( three ),
    power->( three )->( four  ),
);
