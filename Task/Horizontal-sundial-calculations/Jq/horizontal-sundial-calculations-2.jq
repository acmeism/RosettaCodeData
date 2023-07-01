def prompts: [
  { prompt: "Enter latitude: ",       key: "lat", type: "number", help: "in degrees"},
  { prompt: "Enter longitude: ",      key: "lng", type: "number", help: "in degrees"},
  { prompt: "Enter legal meridian: ", key: "ref", type: "number", help: "in degrees"}
];

def task:
  get(prompts)
  | if type != "object" then .  # the prompts
    else
    ((.lat * pi / 180)|sin) as $slat
    | (.lng - .ref) as $diff
    | "\n    sine of latitude : \($slat)",
        "    diff longitude   : \($diff)",
      "\nHour, sun hour angle, dial hour line angle from 6am to 6pm",
      (range(-6;7)  as $h
       | (15*$h - $diff) as $hra
       | (($hra * pi /180)|sin) as $s
       | (($hra * pi /180)|cos) as $c
       | (atan2($slat*$s; $c) * 180 / pi) as $hla
       | [$h|lpad(3)] + ([$hra, $hla] | map(align_decimal(3)|lpad(7))) | join(" ") )
    end;

task
