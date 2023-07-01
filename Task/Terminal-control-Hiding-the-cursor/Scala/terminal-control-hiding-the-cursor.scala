object Main extends App {
  print("\u001B[?25l") // hide cursor
  Thread.sleep(2000) // wait 2 seconds before redisplaying cursor
  print("\u001B[?25h") // display cursor
  Thread.sleep(2000) // wait 2 more seconds before exiting
}
