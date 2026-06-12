def gBase32: "0123456789bcdefghjkmnpqrstuvwxyz";

# Output: the dictionary mapping the characters in gBase32 to bitstrings:
# {"0":"00000", ... "z":"11111"}
def gBase32dict:
  to_object( enumerate(gBase32|explode[]|[.]|implode);
             { (.[1]): (.[0]|convert(2)|lpad(5; "0")) } ) ;

def encodeGeohash($location; $prec):
  { latRange: [ -90,  90],
    lngRange: [-180, 180],
    hash: "",
    hashVal: 0,
    bits: 0,
    even: true
  }
  | until (.hash|length >= $prec;
          .val = if .even then $location[1] else $location[0] end
        | .rng = if .even then .lngRange else .latRange end
        | .mid = (.rng[0] + .rng[1]) / 2
        | if .val > .mid
          then .hashVal |= .*2 + 1
          | .rng = [.mid, .rng[1]]
          | if .even then .lngRange = [.mid, .lngRange[1]] else .latRange = [.mid, .latRange[1]] end
          else .hashVal *= 2
          | if .even then .lngRange = [.lngRange[0], .mid] else .latRange = [.latRange[0], .mid] end
          end
        | .even |= not
        | if .bits < 4 then .bits += 1
          else
            .bits = 0
            | .hash += gBase32[.hashVal:.hashVal+1]
            | .hashVal = 0
	  end)
  | .hash;

def decodeGeohash:
  def flip: if . == 0 then 1 else 0 end;
  def chars: explode[] | [.] | implode;
  # input: a 0/1 string
  # output: a stream of 0/1 integers
  def bits: explode[] | . - 48;

  . as $geo
  | gBase32dict as $gBase32dict
  | {minmaxes: [[-90.0, 90.0], [-180.0, 180.0]], latlong: 1 }
  | reduce ($geo | chars) as $c (.;
      reduce ($gBase32dict[$c]|bits) as $bit (.;
        .minmaxes[.latlong][$bit|flip] = ((.minmaxes[.latlong] | add) / 2)
        | .latlong |= flip))
  | .minmaxes ;

def data:
    [[51.433718, -0.214126],  2],
    [[51.433718, -0.214126],  9],
    [[57.64911,  10.40744 ], 11]
;

data
| encodeGeohash(.[0]; .[1]) as $geohash
| (.[0] | map(lpad(10)) | join(",") | "[\(.)]" ) as $loc
| "geohash for \($loc), precision \(.[1]|lpad(3)) = \($geohash)",
  "  decode => \($geohash|decodeGeohash|map(map(round(6))) )"
