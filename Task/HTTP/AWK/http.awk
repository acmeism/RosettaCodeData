BEGIN {
  site="en.wikipedia.org"
  path="/wiki/"
  name="Rosetta_Code"

  server = "/inet/tcp/0/" site "/80"
  print "GET " path name " HTTP/1.0" |& server
  print "Host: " site |& server
  print "\r\n\r\n" |& server

  while ( (server |& getline fish) > 0 ) {
    if ( ++scale == 1 )
      ship = fish
    else
      ship = ship "\n" fish
  }
  close(server)

  print ship
}
