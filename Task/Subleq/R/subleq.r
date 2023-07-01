mem <- c(15, 17, -1, 17, -1, -1, 16, 1,
         -1, 16, 3, -1, 15, 15, 0, 0,
         -1, 72, 101, 108, 108, 111, 44,
         32, 119, 111, 114, 108, 100,
         33, 10, 0)

getFromMemory <- function(addr) { mem[[addr + 1]] } # because first element in mem is mem[[1]]
setMemory <- function(addr, value) { mem[[addr + 1]] <<- value }
subMemory <- function(x, y) { setMemory(x, getFromMemory(x) - getFromMemory(y)) }

instructionPointer <- 0
while (instructionPointer >= 0) {
  a <- getFromMemory(instructionPointer)
  b <- getFromMemory(instructionPointer + 1)
  c <- getFromMemory(instructionPointer + 2)
  if (b == -1) {
    cat(rawToChar(as.raw(getFromMemory(a))))
  } else {
    subMemory(b, a)
    if (getFromMemory(b) < 1) {
      instructionPointer <- getFromMemory(instructionPointer + 2)
      next
    }
  }
  instructionPointer <- instructionPointer + 3
}
