use "random"
use "collections"

class CreationFactory
  let _desired: String

  new create(d: String) =>
    _desired = d

  fun apply(c: String): Creation =>
    Creation(c, _fitness(c))

  fun _fitness(s: String): USize =>
    var f = USize(0)
    for i in Range(0, s.size()) do
      try
        if s(i) == _desired(i) then
          f = f +1
        end
      end
    end
    f

class val Creation
  let string: String
  let fitness: USize

  new val create(s: String = "", f: USize = 0) =>
    string = s
    fitness = f

class Mutator
  embed _rand: MT = MT
  let _possibilities: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
  let _cf: CreationFactory

  new create(cf: CreationFactory) =>
    _cf = cf

  fun ref apply(parent: Creation, rate: F64): Creation =>
    let ns = _new_string(parent.string, rate)
    _cf(ns)

  fun ref _new_string(parent: String, rate: F64): String =>
    var mutated = recover String(parent.size()) end
    for char in parent.values() do
      mutated.push(_mutate_letter(char, rate))
    end
    consume mutated

  fun ref _mutate_letter(current: U8, rate: F64): U8 =>
    if _rand.real() <= rate then
      _random_letter()
    else
      current
    end

  fun ref _random_letter(): U8 =>
    let ln = _rand.int(_possibilities.size().u64()).usize()
    try _possibilities(ln) else ' ' end

class Generation
  let _size: USize
  let _desired: Creation
  let _mutator: Mutator

  new create(size: USize = 100, desired: Creation, mutator: Mutator) =>
    _size = size
    _desired = desired
    _mutator = consume mutator

  fun ref apply(parent: Creation): Creation =>
    var best = parent
    let mutation_rate = _mutation_rate(best)
    for i in Range(0, _size) do
      let candidate = _mutator(best, mutation_rate)
      if candidate.fitness > best.fitness then
        best = candidate
      end
    end
    best

  fun _mutation_rate(best: Creation): F64 =>
    let min_mutate_rate: F64 = 0.09

    let df = _desired.fitness.f64()
    let bf = best.fitness.f64()

    ((df - bf) / df) * (1.0 - min_mutate_rate)

actor Main
  new create(env: Env) =>
    let d = "METHINKS IT IS LIKE A WEASEL"
    let cf = CreationFactory(d)
    let desired = cf(d)
    let mutator = Mutator(cf)
    let start = mutator(desired, 1.0)
    let spawn_per_generation = USize(100)

    var iterations = U64(0)
    var best = start

    repeat
      best = Generation(spawn_per_generation, desired, mutator)(best)

      iterations = iterations + 1
      if (iterations % 100) == 0 then
        env.out.print(
          iterations.string() + ": "
          + best.string + ", fitness: " + best.fitness.string()
          )
      end
    until best.string == desired.string end

    env.out.print(best.string + ", " + iterations.string())
