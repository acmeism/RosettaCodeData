// We are performing geometric subtraction

difference() {

  // Create the primary sphere of radius 60 centred at the origin

  translate(v = [0,0,0]) {
    sphere(60);
  }

  /*Subtract an overlapping sphere with a radius of 40
     The resultant hole will be smaller than this, because we only
     only catch the edge
  */

  translate(v = [0,90,0]) {
    sphere(40);
  }
}
