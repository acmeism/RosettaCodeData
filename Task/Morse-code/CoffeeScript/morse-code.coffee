class Morse
  constructor : (@unit=0.05, @freq=700) ->

    @cont = new AudioContext()
    @time = @cont.currentTime
    @alfabet = "..etianmsurwdkgohvf.l.pjbxcyzq..54.3...2.......16.......7...8.90"

  getCode : (letter) ->
    i = @alfabet.indexOf letter
    result = ""
    while i > 1
      result = ".-"[i%2] + result
      i //= 2
    result

  makecode : (data) ->
    for letter in data
      code = @getCode letter
      if code != undefined then @maketime code else @time += @unit * 7

  maketime : (data) ->
    for timedata in data
      timedata = @unit * ' . _'.indexOf timedata
      if timedata > 0
        @maketone timedata
        @time += timedata
        @time += @unit * 1
    @time += @unit * 2

  maketone : (data) ->
    start = @time
    stop = @time + data
    @gain.gain.linearRampToValueAtTime 0, start
    @gain.gain.linearRampToValueAtTime 1, start + @unit / 8
    @gain.gain.linearRampToValueAtTime 1, stop - @unit / 16
    @gain.gain.linearRampToValueAtTime 0, stop

  send : (text) ->
    osci = @cont.createOscillator()
    osci.frequency.value = @freq
    @gain = @cont.createGain()
    @gain.gain.value = 0
    osci.connect @gain
    @gain.connect @cont.destination

    osci.start @time
    @makecode text
    @cont

morse = new Morse()
morse.send 'hello world 0123456789'
