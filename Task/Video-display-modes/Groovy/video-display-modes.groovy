def invoke(String cmd) { println(cmd.execute().text) }

invoke("xrandr -q")
Thread.sleep(3000)

invoke("xrandr -s 1024x768")
Thread.sleep(3000)

invoke("xrandr -s 1366x768")
