f, r = nil
fwd = proc {|c|
  c =~ /[[:alpha:]]/ ? [(print c), fwd[Fiber.yield f]][1] : c }
rev = proc {|c|
  c =~ /[[:alpha:]]/ ? [rev[Fiber.yield r], (print c)][0] : c }

(f = Fiber.new { loop { print fwd[Fiber.yield r] }}).resume
(r = Fiber.new { loop { print rev[Fiber.yield f] }}).resume

coro = f
until $stdin.eof?
  coro = coro.resume($stdin.getc)
end
