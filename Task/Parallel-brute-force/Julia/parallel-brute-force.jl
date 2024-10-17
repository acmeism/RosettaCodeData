@everywhere using SHA

@everywhere function bruteForceRange(startSerial, numberToDo)
  targets = ["1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
             "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
             "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"]
  targets = map(hex2bytes, targets)
  for count = 1 : numberToDo
    password = [UInt8(97 + x) for x in digits(UInt8, startSerial + count, 26, 5)]
    hashbytes = sha256(password)
    if (hashbytes[1] == 0x11 || hashbytes[1] == 0x3a || hashbytes[1] == 0x74) && findfirst(targets, hashbytes) > 0
      hexstring = join(hex(x,2) for x in hashbytes)
      passwordstring = join(map(Char, password))
      println("$passwordstring --> $hexstring")
    end
  end
  return 0
end

@everywhere perThread = div(26^5, Sys.CPU_CORES)
pmap(x -> bruteForceRange(x * perThread, perThread), 0:Sys.CPU_CORES-1)
