package require Tk
package require img::jpeg

proc output_jpeg {image filename} {
    $image write $filename -format jpeg
}
set img [image create photo -filename filename.ppm]
output_jpeg $img filename.jpg
