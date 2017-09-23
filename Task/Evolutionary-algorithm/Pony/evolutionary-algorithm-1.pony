use "random"

actor Main
  let _env: Env
  let _rand: MT = MT	// Mersenne Twister
  let _target: String = "METHINKS IT IS LIKE A WEASEL"
  let _possibilities: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
  let _c: U16 = 100	// number of spawn per generation
  let _min_mutate_rate: F64 = 0.09
  let _perfect_fitness: USize = _target.size()
  var _parent: String = ""

  new create(env: Env) =>
    _env = env
    _parent = mutate(_target, 1.0)
    var iter: U64 = 0
    while not _target.eq(_parent) do
      let rate: F64 = new_mutate_rate()
      iter = iter + 1
      if (iter % 100) == 0 then
        _env.out.write(iter.string() + ": " + _parent)
        _env.out.write(", fitness: " + fitness(_parent).string())
        _env.out.print(", rate: " + rate.string())
      end
      var best_spawn = ""
      var best_fit: USize = 0
      var i: U16 = 0
      while i < _c do
        let spawn = mutate(_parent, rate)
        let spawn_fitness = fitness(spawn)
        if spawn_fitness > best_fit then
          best_spawn = spawn
          best_fit = spawn_fitness
        end
        i = i + 1
      end
      if best_fit > fitness(_parent) then
        _parent = best_spawn
      end
    end
    _env.out.print(_parent + ", " + iter.string())

  fun fitness(trial: String): USize =>
    var ret_val: USize = 0
    var i: USize = 0
    while i < trial.size() do
      try
        if trial(i)? == _target(i)? then
          ret_val = ret_val + 1
        end
      end
      i = i + 1
    end
    ret_val

  fun new_mutate_rate(): F64 =>
    let perfect_fit = _perfect_fitness.f64()
    ((perfect_fit - fitness(_parent).f64()) / perfect_fit) * (1.0 - _min_mutate_rate)

  fun ref mutate(parent: String box, rate: F64): String =>
    var ret_val = recover trn String end
    for char in parent.values() do
      let rnd_real: F64 = _rand.real()
      if rnd_real <= rate then
        let rnd_int: U64 = _rand.int(_possibilities.size().u64())
        try
          ret_val.push(_possibilities(rnd_int.usize())?)
        end
      else
        ret_val.push(char)
      end
    end
    consume ret_val
