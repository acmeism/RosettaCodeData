val seed = (47,42);
val gen = Random.rand seed;
fun random_gaussian () =
  1.0 + Math.sqrt (~2.0 * Math.ln (Random.randReal gen)) * Math.cos (2.0 * Math.pi * Random.randReal gen);
val a = List.tabulate (1000, fn _ => random_gaussian ());
