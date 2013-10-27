def text = (0..255).collect { (char) it }.join('')
def textMinusControl = text.findAll { int v = (char)it; v > 31 && v != 127 }.join('')
def textMinusControlAndExtended = textMinusControl.findAll {((char)it) < 128 }.join('')

assert stripControl(text) == textMinusControl
assert stripControlAndExtended(text) == textMinusControlAndExtended
