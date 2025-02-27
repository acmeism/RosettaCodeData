// Horizontal sundial calculations

function deg2rad(d) {
  return d * Math.PI / 180;
}

function rad2deg(r) {
  return r / Math.PI * 180;
}

document.write("<span style=\"font-family:Lucida Console\">");
lat = prompt("Enter latitude");
document.write("<p>Latitude: ", lat);
lng = prompt("Enter longitude");
document.write("<br />Longitude: ", lng);
ref = prompt("Enter legal meridian");
document.write("<br />Legal meridian: ", ref);
document.write("</p>");
sLat = Math.sin(deg2rad(lat));
document.write("<p>Sine of latitude:    ", sLat.toFixed(5));
document.write("<br />Diff longitude:      ", (lng - ref).toFixed(5));
document.write("</p>");
document.write("<table>");
document.write("<colgroup><col style=\"background-color: #EEEEEE\">");
document.write("<col>");
document.write("<col style=\"background-color: #EEEEEE\">");
document.write("</colgroup>");
document.write("<tr><th>Time</th><th>Sun hour angle</th>",
               "<th>Dial hour line angle</th></tr>");
for (hour = -6; hour <= 6; hour++) {
  hourAngle = 15 * hour - (lng - ref);
  hourLineAngle = rad2deg(Math.atan(sLat * Math.tan(deg2rad(hourAngle))));
  document.write("<tr style=\"text-align:right\">");
  document.write("<td>", (hour + 12).toFixed(), ":00</td>");
  document.write("<td style=\"padding-right:20px\">", hourAngle.toFixed(5),
                 "</td>");
  document.write("<td style=\"padding-right:20px\">", hourLineAngle.toFixed(5),
                 "</td></tr>");
}
document.write("</table>");
document.write("</span>");
