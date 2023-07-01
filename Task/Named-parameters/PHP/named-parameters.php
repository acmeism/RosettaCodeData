function named($args) {
  $args += ["gbv" => 2,
            "motor" => "away",
            "teenage" => "fbi"];
  echo $args["gbv"] . " men running " . $args['motor'] . " from the " . $args['teenage'];
}

named(["teenage" => "cia", "gbv" => 10]);
