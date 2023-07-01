with Interfaces; use Interfaces;
...
type Octet is new Interfaces.Unsigned_8;
type Octet_String is array (Positive range <>) of Octet;
