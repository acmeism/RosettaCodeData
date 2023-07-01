def bottles = { "${it==0 ? 'No more' : it} bottle${it==1 ? '' : 's' }" }

def initialState = {
  """${result(it)}
${resultShort(it)}"""
}

def act = {
  it > 0 ?
      "Take ${it==1 ? 'it' : 'one'} down, pass it around" :
      "Go to the store, buy some more"
}

def delta = { it > 0 ? -1 : 99 }

def resultShort = { "${bottles(it)} of beer" }

def result = { "${resultShort(it)} on the wall" }

// //// uncomment commented lines to create endless drunken binge //// //
// while (true) {
99.downto(0) { i ->
  print """
${initialState(i)}
${act(i)}
${result(i+delta(i))}
"""
}
// Thread.sleep(1000)
// }
