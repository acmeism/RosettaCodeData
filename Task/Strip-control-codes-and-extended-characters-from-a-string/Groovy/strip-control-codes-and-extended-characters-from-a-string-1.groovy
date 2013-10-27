def stripControl = { it.replaceAll(/\p{Cntrl}/, '') }
def stripControlAndExtended = { it.replaceAll(/[^\p{Print}]/, '') }
