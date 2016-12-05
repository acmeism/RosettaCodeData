import UIKit

extension CGFloat {
  func degrees_to_radians() -> CGFloat {
    return CGFloat(M_PI) * self / 180.0
  }
}

extension Double {
  func degrees_to_radians() -> Double {
    return Double(M_PI) * self / 180.0
  }

}


class Tree: UIView {


  func drawTree(x1: CGFloat, y1: CGFloat, angle: CGFloat, depth:Int){
    if depth == 0 {
      return
    }
    let ang = angle.degrees_to_radians()
    let x2:CGFloat = x1 + ( cos(ang) as CGFloat) * CGFloat(depth) * (self.frame.width / 60)
    let y2:CGFloat = y1 + ( sin(ang) as CGFloat) * CGFloat(depth) * (self.frame.width / 60)

    let line = drawLine(x1, y1: y1, x2: x2, y2: y2)

    line.stroke()
    drawTree(x2, y1: y2, angle: angle - 20, depth: depth - 1)
    drawTree(x2, y1: y2, angle: angle + 20, depth: depth - 1)
  }

  func drawLine(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) -> UIBezierPath
  {

    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: x1,y: y1))
    path.addLineToPoint(CGPoint(x: x2,y: y2))
    path.lineWidth = 1
    return path
  }

  override func drawRect(rect: CGRect) {

    let color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    color.set()
    drawTree(self.frame.width / 2 , y1: self.frame.height * 0.8, angle: -90 , depth: 9 )
  }


}


let tree = Tree(frame: CGRectMake(0, 0, 300, 300))
tree
