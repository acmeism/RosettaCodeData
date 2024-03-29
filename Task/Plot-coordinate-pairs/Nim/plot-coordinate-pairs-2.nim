import ggplotnim

let
  x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  y = [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0]

let df = seqsToDf(x, y)   # Build a dataframe.

df.ggplot(aes("x", "y")) +
  ggtitle("Coordinate pairs") +
  geomLine() +
  themeOpaque() +
  ggsave("coordinate_pairs.png")
