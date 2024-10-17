xs = for _ <- 1..1000, do: 1.0 + :rand.normal * 0.5
std_dev.(xs)
