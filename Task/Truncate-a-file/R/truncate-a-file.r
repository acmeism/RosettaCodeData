truncate_file <- function(filename, n_bytes) {

  # check file exists and size is greater than n_bytes
  stopifnot(
    "file does not exist"= file.exists(filename),
    "not enough bytes in file"= file.size(filename) >= n_bytes
  )

  # read bytes from input file
  input.con <- file(filename, "rb")
  bindata <- readBin(input.con, integer(), n=n_bytes/4)
  close(input.con)

  # write bytes to temporary file
  tmp.filename <- tempfile()
  output.con <- file(tmp.filename, "wb")
  writeBin(bindata, output.con)
  close(output.con)

  # double check that everything worked before overwriting original file
  stopifnot(
    "temp file is not expected size"= file.size(tmp.filename) == n_bytes
  )

  # overwrite input file with temporary file
  file.rename(tmp.filename, filename)

}
