#20200615 Raku programming solution

use Geo::Hash;

# task example 1 : Ireland, most of England and Wales, small part of Scotland
say geo-encode(51.433718e0, -0.214126e0, 2);

# task example 2 : the umpire's chair on Center Court at Wimbledon
say geo-encode(51.433718e0, -0.214126e0, 9);

# Lake Raku is an artificial lake in Tallinn, Estonia
# https://goo.gl/maps/MEBXXhiFbN8WMo5z8
say geo-encode(59.358639e0, 24.744778e0, 4);

# Village Raku is a development committee in north-western Nepal
# https://goo.gl/maps/33s7k2h3UrHCg8Tb6
say geo-encode(29.2021188e0, 81.5324561e0, 4);
