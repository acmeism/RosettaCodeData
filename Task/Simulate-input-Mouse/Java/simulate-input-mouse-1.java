Point p = component.getLocation();
Robot robot = new Robot();
robot.mouseMove(p.getX(), p.getY()); //you may want to move a few pixels closer to the center by adding to these values
robot.mousePress(InputEvent.BUTTON1_MASK); //BUTTON1_MASK is the left button,
                                       //BUTTON2_MASK is the middle button, BUTTON3_MASK is the right button
robot.mouseRelease(InputEvent.BUTTON1_MASK);
