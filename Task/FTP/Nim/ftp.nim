import asyncdispatch, asyncftpclient

const
  Host = "speedtest.tele2.net"
  Upload = "upload"
  File = "1KB.zip"

proc main {.async.} =

  # Create session and connect.
  let ftp = newAsyncFtpClient(Host, user = "anonymous", pass = "anything")
  await ftp.connect()
  echo "Connected."
  echo await ftp.send("PASV")   # Switch to passive mode.

  # Change directory and list its contents.
  await ftp.cd(Upload)
  echo "Changed to directory: ", Upload
  echo "Contents of directory: ", Upload
  for file in await ftp.listDirs():
    echo "  ", file

  # Download a file.
  await ftp.cd("/")
  echo "Returned to root directory."
  await ftp.retrFile(file = File, dest = File)
  echo "Downloaded file: ", File
  echo await ftp.send("QUIT")   # Disconnect.

waitFor main()
