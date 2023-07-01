new File('output.txt').withWriter( w ->
  new File('input.txt').withReader( r -> w << r }
}
