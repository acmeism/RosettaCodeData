import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
    input_string:="She was a soul stripper. She took my heart!"
    filter_string:="aei"

    for i in filter_string{
        rune_array:=[]rune{i}
        filter:=utf8.runes_to_string(rune_array)
        input_string,_=strings.replace(input_string, filter, "", -1)
    }
    fmt.println(input_string)

}
