def task($count):
  range (2; 37) as $b
  | select( $b | is_prime | not)
  | [ limit($count; rhondas($b)) ]
  | select(length > 0)
  |"First \($count) Rhonda numbers in base \($b):",
    (   (map(tostring)) as $rhonda2
      | (map(tobase($b))) as $rhonda3
      | (($rhonda2|map(length)) | max) as $maxLen2
      | (($rhonda3|map(length)) | max) as $maxLen3
      | ( ([$maxLen2, $maxLen3]|max) + 1) as $maxLen
      | "In base 10:  \($rhonda2 | map(lpad($maxLen)) | join(" ") )",
        "In base \($b|lpad(2)):  \($rhonda3 | map(lpad($maxLen)) | join(" ") )",
        "") ;

task(10)
