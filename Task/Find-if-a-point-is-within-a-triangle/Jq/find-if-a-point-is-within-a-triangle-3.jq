def task1:
  def pts: [ [0, 0], [0, 1], [3, 1]];
  "Triangle is \(.)",
   (. as [$P1, $P2, $P3]
    | pts[] as $Q
    | accuratePointInTriangle($P1; $P2; $P3; $Q) as $within
    | "Point \($Q) is within triangle ? \($within)"
   );

def task2:
  "Triangle is \(.)",
  (. as [$P1, $P2, $P3]
   | [ $P1[0] + (3/7)*($P2[0] - $P1[0]), $P1[1] + (3/7)*($P2[1] - $P1[1]) ] as $Q
   | accuratePointInTriangle($P1; $P2; $P3; $Q) as $within
   | "Point \($Q) is within triangle ? \($within)"
   );

([ [3/2, 12/5], [51/10, -31/10], [-19/5,   1.2] ] | task1), "",
([ [1/10, 1/9], [100/8,  100/3], [100/4, 100/9] ] | task2), "",
([ [1/10, 1/9], [100/8, 100/3], [-100/8, 100/6] ] | task2)
