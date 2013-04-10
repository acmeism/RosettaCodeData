def storage := [].diverge()

def logService {
  to log(line :String) {
    storage.push([timer.now(), line])
  }
  to search(substring :String) {
    var matches := []
    for [time, line] ? (line.startOf(substring) != -1) in storage {
      matches with= [time, line]
    }
    return matches
  }
}

introducer.onTheAir()
def sturdyRef := makeSturdyRef.temp(logService)
println(<captp>.sturdyToURI(sturdyRef))
interp.blockAtTop()
