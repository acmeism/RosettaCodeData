class Sphere: UIView{

  override func drawRect(rect: CGRect)
  {
    let context = UIGraphicsGetCurrentContext()
    let locations: [CGFloat] = [0.0, 1.0]

    let colors = [UIColor.whiteColor().CGColor,
      UIColor.blueColor().CGColor]

    let colorspace = CGColorSpaceCreateDeviceRGB()

    let gradient = CGGradientCreateWithColors(colorspace,
      colors, locations)

    var startPoint = CGPoint()
    var endPoint = CGPoint()
    startPoint.x = self.center.x - (self.frame.width * 0.1)
    startPoint.y = self.center.y - (self.frame.width * 0.15)
    endPoint.x = self.center.x
    endPoint.y = self.center.y
    let startRadius: CGFloat = 0
    let endRadius: CGFloat = self.frame.width * 0.38

    CGContextDrawRadialGradient (context, gradient, startPoint,
      startRadius, endPoint, endRadius,
      0)
  }
}

var s = Sphere(frame: CGRectMake(0, 0, 200, 200))
