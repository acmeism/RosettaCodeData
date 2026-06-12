vfix lst = map ($vfix lst) lst

-- example usage: mutual recurrence relation of mod3

h1 [h1, h2, h3] n = if n == 0 then 0 else h2 (n - 1)
h2 [h1, h2, h3] n = if n == 0 then 1 else h3 (n - 1)
h3 [h1, h2, h3] n = if n == 0 then 2 else h1 (n - 1)
mod3 = head $ vfix [h1, h2, h3]

main = print $ mod3 <$> [0 .. 10]
