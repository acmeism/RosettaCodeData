def diversitytheorem($actual; $predicted):
  def mean: add/length;

  ($predicted | mean) as $mean
  | { avgerr: ($predicted | map(. - $actual) | map(pow(.; 2)) | mean),
      crderr: pow($mean - $actual; 2),
      divers: ($predicted | map(. - $mean) | map(pow(.;2)) | mean) } ;
