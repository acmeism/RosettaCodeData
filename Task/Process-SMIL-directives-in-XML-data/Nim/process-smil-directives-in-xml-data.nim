import sequtils, strformat, strtabs, strutils, xmlparser, xmltree

type

  Animation = object
    attrName: string          # Attribute to animate.
    fromValues: seq[float]    # List of "from" values.
    toValues: seq[float]      # List of "to" values.
    begin: float              # Animation starting time.
    duration: float           # Animation duration.


func getAnim(node: XmlNode): Animation =
  ## Build an animation object from an XML node.

  result.attrName = node.attr("attributeName")
  if result.attrName.len == 0:
    raise newException(ValueError, "missing 'attributeName' attribute")
  var str = node.attr("from")
  if str.len == 0:
    raise newException(ValueError, "missing 'from' attribute")
  result.fromValues = str.splitWhitespace().map(parseFloat)
  str = node.attr("to")
  if str.len == 0:
    raise newException(ValueError, "missing 'to' attribute")
  result.toValues = str.splitWhitespace().map(parseFloat)
  if result.fromValues.len != result.toValues.len:
    raise newException(ValueError, "inconsistent number of values")
  str = node.attr("begin")
  if str.len == 0:
    raise newException(ValueError, "missing 'begin' attribute")
  if str[^1] != 's':
    raise newException(ValueError, "missing unit")
  result.begin = parseFloat(str[0..^2])
  str = node.attr("dur")
  if str.len == 0:
    raise newException(ValueError, "missing 'dur' attribute")
  if str[^1] != 's':
    raise newException(ValueError, "missing unit")
  result.duration = parseFloat(str[0..^2])


func buildXml(node: XmlNode; t: float): XmlNode =
  ## Build the XML tree of a SMIL animation at time "t".

  if node.len > 0 and node[0].tag == "animate":
    # Child is an animate node.
    let anim = node[0].getAnim()
    # Check attribute name.
    if node.attr(anim.attrName).len == 0:
      raise newException(ValueError, &"unable to find attribute '{anim.attrName}'")
    # Check time.
    if t notin anim.begin..(anim.begin + anim.duration):
      raise newException(ValueError, "time value out of range")
    # Build attribute value.
    var aVal = newSeq[float](anim.fromValues.len)
    for i in 0..aVal.high:
      aVal[i] = (anim.fromValues[i] * (anim.begin + anim.duration - t) +
                 anim.toValues[i] * (t - anim.begin)) / anim.duration
    # Set attributes.
    let a = node.attrs
    a[anim.attrName] = aVal.mapIt(it.formatFloat(ffDefault, 2)).join(" ")
    result = newElement(node.tag)
    result.attrs = a

  else:
    # Node child (if any) is not an animate node: copy the node and process children.
    result = newElement(node.tag)
    result.attrs = node.attrs
    for child in node:
      result.add child.buildXml(t)


when isMainModule:
  let smil = loadXml("smil.xml")
  if smil.tag != "smil":
    raise newException(ValueError, "not a SMIL file")
  let newRoot = smil[0]
  echo "At time 0 second:\n"
  echo xmlHeader, newRoot.buildXml(0)
  echo "\nAt time 2 seconds:\n"
  echo xmlHeader, newRoot.buildXml(2)
