def logical(a: Boolean, b: Boolean): IO[Unit] = for {
  _ <- putStrLn("and: " ++ (a && b).shows)
  _ <- putStrLn("or:  " ++ (a || b).shows)
  _ <- putStrLn("not: " ++ (!a).shows)
} yield ()

logical(true, false).unsafePerformIO
