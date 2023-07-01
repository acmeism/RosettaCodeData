import java.util.Scanner

import scala.math.{atan2, cos, sin, toDegrees, toRadians}

object Sundial extends App {
  var lat, slat,lng, ref = .0
  val sc = new Scanner(System.in)
  print("Enter latitude: ")
  lat = sc.nextDouble
  print("Enter longitude: ")
  lng = sc.nextDouble
  print("Enter legal meridian: ")
  ref = sc.nextDouble
  println()
  slat = Math.sin(Math.toRadians(lat))
  println(f"sine of latitude: $slat%.3f")
  println(f"diff longitude: ${lng - ref}%.3f\n")
  println("Hour, sun hour angle, dial hour line angle from 06h00 to 18h00")

  for (h <- -6 to 6) {
    val hra = 15.0 * h - lng + ref
    val hraRad = toRadians(hra)
    val hla = toDegrees(atan2(Math.sin(hraRad) * sin(Math.toRadians(lat)), cos(hraRad)))
    println(f"HR= $h%3d;\tHRA=$hra%7.3f;\tHLA= $hla%7.3f")
  }

}
