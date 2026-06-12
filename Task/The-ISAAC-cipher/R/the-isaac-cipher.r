# ISAAC Cipher Implementation in R
# Maximum length of message
MAXMSG <- 4096

# Helper function to ensure 32-bit unsigned integer behavior
uint32 <- function(x) {
  x <- as.numeric(x)
  x <- x %% (2^32)
  return(x)
}

# Custom XOR for unsigned 32-bit integers
xor32 <- function(a, b) {
  a <- uint32(a)
  b <- uint32(b)

  # Convert to binary and XOR bit by bit
  result <- 0
  for (i in 0:31) {
    bit_a <- (floor(a / (2^i)) %% 2)
    bit_b <- (floor(b / (2^i)) %% 2)
    if (bit_a != bit_b) {
      result <- result + 2^i
    }
  }
  return(uint32(result))
}

# Safe bitwise shift left
shift_left <- function(x, n) {
  uint32(uint32(x) * (2^n))
}

# Safe bitwise shift right
shift_right <- function(x, n) {
  floor(uint32(x) / (2^n))
}

# IState structure
create_istate <- function() {
  list(
    randrsl = rep(0, 256),
    randcnt = 0,
    mm = rep(0, 256),
    aa = 0,
    bb = 0,
    cc = 0
  )
}

# isaac - Randomize the pool
isaac <- function(istate) {
  istate$cc <- uint32(istate$cc + 1)
  istate$bb <- uint32(istate$bb + istate$cc)

  for (j in 1:256) {
    i <- j - 1
    xmod4 <- i %% 4

    if (xmod4 == 0) {
      istate$aa <- xor32(istate$aa, shift_left(istate$aa, 13))
    } else if (xmod4 == 1) {
      istate$aa <- xor32(istate$aa, shift_right(istate$aa, 6))
    } else if (xmod4 == 2) {
      istate$aa <- xor32(istate$aa, shift_left(istate$aa, 2))
    } else {
      istate$aa <- xor32(istate$aa, shift_right(istate$aa, 16))
    }

    istate$aa <- uint32(istate$aa + istate$mm[(i + 128) %% 256 + 1])
    c_val <- istate$mm[j]
    y <- uint32(istate$mm[shift_right(c_val, 2) %% 256 + 1] + istate$aa + istate$bb)
    istate$mm[j] <- y
    istate$bb <- uint32(istate$mm[shift_right(y, 10) %% 256 + 1] + c_val)
    istate$randrsl[j] <- istate$bb
  }

  istate$randcnt <- 0
  return(istate)
}

# mix - Mix the bytes in a reversible way
mix <- function(arr) {
  a <- uint32(arr[1]); b <- uint32(arr[2]); c <- uint32(arr[3]); d <- uint32(arr[4])
  e <- uint32(arr[5]); f <- uint32(arr[6]); g <- uint32(arr[7]); h <- uint32(arr[8])

  a <- xor32(a, shift_left(b, 11)); d <- uint32(d + a); b <- uint32(b + c)
  b <- xor32(b, shift_right(c, 2));  e <- uint32(e + b); c <- uint32(c + d)
  c <- xor32(c, shift_left(d, 8));  f <- uint32(f + c); d <- uint32(d + e)
  d <- xor32(d, shift_right(e, 16)); g <- uint32(g + d); e <- uint32(e + f)
  e <- xor32(e, shift_left(f, 10)); h <- uint32(h + e); f <- uint32(f + g)
  f <- xor32(f, shift_right(g, 4));  a <- uint32(a + f); g <- uint32(g + h)
  g <- xor32(g, shift_left(h, 8));  b <- uint32(b + g); h <- uint32(h + a)
  h <- xor32(h, shift_right(a, 9));  c <- uint32(c + h); a <- uint32(a + b)

  c(a, b, c, d, e, f, g, h)
}

# randinit - Initialize random array
randinit <- function(istate, flag) {
  istate$aa <- 0
  istate$bb <- 0
  istate$cc <- 0

  mixer <- rep(0x9e3779b9, 8)

  # Scramble it
  for (i in 1:4) {
    mixer <- mix(mixer)
  }

  # Fill in mm[] with messy stuff
  for (i in seq(0, 255, by = 8)) {
    if (flag) {
      mixer <- sapply(1:8, function(j) uint32(mixer[j] + istate$randrsl[i + j]))
    }
    mixer <- mix(mixer)
    istate$mm[(i + 1):(i + 8)] <- mixer
  }

  if (flag) {
    for (i in seq(0, 255, by = 8)) {
      mixer <- sapply(1:8, function(j) uint32(mixer[j] + istate$mm[i + j]))
      mixer <- mix(mixer)
      istate$mm[(i + 1):(i + 8)] <- mixer
    }
  }

  istate <- isaac(istate)
  istate$randcnt <- 0
  return(istate)
}

# irandom - Get a random 32-bit value
irandom <- function(istate) {
  retval <- istate$randrsl[istate$randcnt + 1]
  istate$randcnt <- istate$randcnt + 1

  if (istate$randcnt > 255) {
    istate <- isaac(istate)
    istate$randcnt <- 0
  }

  list(value = retval, istate = istate)
}

# iranda - Get a random character in printable ASCII range
iranda <- function(istate) {
  result <- irandom(istate)
  char_val <- uint32(result$value) %% 95 + 32
  list(value = char_val, istate = result$istate)
}

# vernam - XOR cipher on random stream
vernam <- function(istate, msg) {
  result <- integer(length(msg))
  for (i in 1:length(msg)) {
    rand_result <- iranda(istate)
    istate <- rand_result$istate
    result[i] <- xor32(rand_result$value, msg[i])
  }
  list(result = result, istate = istate)
}

# iseed - Seed ISAAC with a string
iseed <- function(istate, seed, flag) {
  istate$mm <- rep(0, 256)
  istate$randrsl <- rep(0, 256)

  len <- min(length(seed), length(istate$randrsl))
  if (len > 0) {
    istate$randrsl[1:len] <- seed[1:len]
  }

  istate <- randinit(istate, flag)
  return(istate)
}

# tohexstring - Convert byte array to hex string
tohexstring <- function(arr) {
  paste(sprintf("%02x", arr), collapse = "")
}

# test - Test encryption and decryption
test <- function(istate, msg, key) {
  # Convert strings to byte arrays
  msg_bytes <- as.integer(charToRaw(msg))
  key_bytes <- as.integer(charToRaw(key))

  # Encrypt: Vernam XOR
  istate <- iseed(istate, key_bytes, TRUE)
  vctx_result <- vernam(istate, msg_bytes)
  vctx <- vctx_result$result

  # Decrypt: Vernam XOR
  istate <- iseed(create_istate(), key_bytes, TRUE)
  vptx_result <- vernam(istate, vctx)
  vptx <- vptx_result$result

  # Program output
  cat("Message:", msg, "\n")
  cat("Key    :", key, "\n")
  cat("XOR    :", tohexstring(vctx), "\n")
  cat("XOR dcr:", rawToChar(as.raw(vptx)), "\n")

  return(0)
}

# Run the test
msg <- "a Top Secret secret"
key <- "this is my secret key"
test(create_istate(), msg, key);
