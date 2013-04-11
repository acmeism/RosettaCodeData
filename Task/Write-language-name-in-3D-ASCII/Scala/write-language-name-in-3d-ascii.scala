def ASCII3D = {

  val name = """
               *
   **  **  *   *    *
  *   *   * *  *   * *
  *   *   * *  *   * *
   *  *   ***  *   ***
    * *   * *  *   * *
    * *   * *  *   * *
  **   ** *  * *** * *
                     *
                      *
  """


  //
  // Create Array
  //

  def getMaxSize( s:String ) : (Int,Int) = {

    var width = 0
    var height = 0

    val nameArray = s.split("\n")

    height = nameArray.size
    nameArray foreach {i => width = (i.size max width)}

    (width,height)
  }

  val size = getMaxSize( name )

  var arr = Array.fill( size._2+1, (size._1*3)+(size._2+1) )( ' ' )


  //
  // Map astrisk to 3D cube
  //
  val cubeTop    = """///\"""
  val cubeBottom = """\\\/"""

  val nameArray = name.split("\n")

  for( j <- (0 until nameArray.size) ) {

    for( i <- (0 until nameArray(j).size) ) {

      if( nameArray(j)(i) == '*' )
      {
        val indent = nameArray.size - j

        arr(j  ) = arr(j  ) patch ((i*3 + indent), cubeTop, cubeTop.size)
        arr(j+1) = arr(j+1) patch ((i*3 + indent), cubeBottom, cubeBottom.size)
      }
    }
  }

  //
  // Map Array to String
  //
  var name3D = ""

  for( j <- (0 until arr.size) )  {

    for( i <- (0 until arr(j).size) ) { name3D += arr(j)(i) }

    name3D += "\n"
  }

  name3D
}

println(ASCII3D)
