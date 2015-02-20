  val (p , robot)= (component.location, new Robot())
  robot.mouseMove(p.getX().toInt, p.getY().toInt) //you may want to move a few pixels closer to the center by adding to these values
  robot.mousePress(InputEvent.BUTTON1_MASK) //BUTTON1_MASK is the left button
  robot.mouseRelease(InputEvent.BUTTON1_MASK)
