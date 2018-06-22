use "files"
		
actor Main
  let _env: Env // The environment contains stdout, so we save it here

  new create(env: Env) =>
    _env = env
    let printer: Printer tag = Printer(env)
    try
      let path = FilePath(env.root as AmbientAuth, "input.txt")? // this may fail, hence the ?
      let file = File.open(path)
      for line in FileLines(file) do
        printer(line) // sugar for "printer.apply(line)"
      end
    end
    printer.done(this)

  be finish(count: USize) =>
    _env.out.print("Printed: " + count.string() + " lines")

		
actor Printer
  let _env: Env
  var _count: USize = 0
  new create(env: Env) => _env = env

  be apply(line: String) =>
    _count = _count + 1
    _env.out.print(line)

  be done(main: Main tag) => main.finish(_count)
