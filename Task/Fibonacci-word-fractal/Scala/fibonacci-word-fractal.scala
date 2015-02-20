def fibIt = Iterator.iterate(("1","0")){case (f1,f2) => (f2,f1+f2)}.map(_._1)

def turnLeft(c: Char): Char = c match {
  case 'R' => 'U'
  case 'U' => 'L'
  case 'L' => 'D'
  case 'D' => 'R'
}

def turnRight(c: Char): Char = c match {
  case 'R' => 'D'
  case 'D' => 'L'
  case 'L' => 'U'
  case 'U' => 'R'
}

def directions(xss: List[(Char,Char)], current: Char = 'R'): List[Char] = xss match {
  case Nil => current :: Nil
  case x :: xs => x._1 match {
    case '1' => current :: directions(xs, current)
    case '0' => x._2 match {
      case 'E' => current :: directions(xs, turnLeft(current))
      case 'O' => current :: directions(xs, turnRight(current))
    }
  }
}

def buildIt(xss: List[Char], old: Char = 'X', count: Int = 1): List[String] = xss match {
  case Nil => s"$old$count" :: Nil
  case x :: xs if x == old => buildIt(xs,old,count+1)
  case x :: xs => s"$old$count" :: buildIt(xs,x)
}

def convertToLine(s: String, c: Int): String = (s.head, s.tail) match {
  case ('R',n) => s"l ${c * n.toInt} 0"
  case ('U',n) => s"l 0 ${-c * n.toInt}"
  case ('L',n) => s"l ${-c * n.toInt} 0"
  case ('D',n) => s"l 0 ${c * n.toInt}"
}

def drawSVG(xStart: Int, yStart: Int, width: Int, height: Int, fibWord: String, lineMultiplier: Int, color: String): String = {
  val xs = fibWord.zipWithIndex.map{case (c,i) => (c, if(c == '1') '_' else i % 2 match{case 0 => 'E'; case 1 => 'O'})}.toList
  val fractalPath = buildIt(directions(xs)).tail.map(convertToLine(_,lineMultiplier))
  s"""<?xml version="1.0" encoding="utf-8"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="${width}px" height="${height}px" viewBox="0 0 $width $height"><path d="M $xStart $yStart ${fractalPath.mkString(" ")}" style="stroke:#$color;stroke-width:1" stroke-linejoin="miter" fill="none"/></svg>"""
}

drawSVG(0,25,550,530,fibIt.drop(18).next,3,"000")
