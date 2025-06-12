package bf

import "core:fmt"
import "core:c/libc"
import "core:os"

cells_size :: 2000
getinp : i32
inp : u8
main :: proc() {

	// comment out to give a file from command line
    // data, ok := os.read_entire_file(os.args[1])
    // assert(ok, "Could not open file")
    // defer delete(data)
    // input := string(data)
	
    input := ">+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.[-]>++++++++[<++++>-] <.>+++++++++++[<++++++++>-]<-.--------.+++.------.--------.[-]>++++++++[<++++>- ]<+.[-]++++++++++."
    size_input := len(input)
    cells : [cells_size]i32
    pointer:=0
    i:=0
    direction := 1
    // moving past non matching [ ]
    depth:= 0
    // loop i over input
    mainloop: for ; (i <= (size_input - 1) && i >=0); {
        inp = input[i]
        //fmt.println(i)
        switch inp{
          // move pointer right
           case '>':
                pointer +=1
                if (pointer>cells_size-1){
                    pointer=cells_size-1
                }
                i += 1
           // move pointer left
           case '<':
                pointer -=1
                if (pointer<0){
                    pointer=0
                }
                i += 1
           // increase cells at pointer
           case '+':
                cells[pointer] = (cells[pointer] + 1) % 256
                i += 1
           // decrease cell at pointer
           case '-':
                cells[pointer] = (cells[pointer] - 1) % 256
                i += 1
           // output value from cell at pointer
           case '.':
                res := cells[pointer]
                libc.putchar(res)
                i += 1
             // input value in cell at pointer
           case ',':
                    getinp= libc.getchar()
                    fmt.println("input:")
                    cells[pointer] = getinp
                    i += 1
            // Jump past the matching ] if the cell at the pointer is 0
           case '[':
               // if cell at pointer = 0
                if cells[pointer] == 0 {
                    // loop until ]

                    loop1: for  (inp != ']' && depth == 0) {
                            i +=1
                            inp = input[i]
                            if (i > (size_input-1)){
                              // if i > size input [ is unbalanced
                              fmt.printf("unbalanced loop ")
                              break mainloop
                            }
                            else if (inp == '[') {
                              depth += 1
                            }
                            else if (inp == ']' && depth != 0) {
                              depth -= 1
                            }

                            fmt.println(i)
                        }

                } // else ignore
                else {
                    i +=1
                }

           case ']':
                // Jump back to the matching [ if the cell at the pointer is nonzero
                if cells[pointer] != 0 {

                    loop2: for (inp!= '[' && depth == 0) {
                         i -= 1
                         inp = input[i]
                         if (i < 0)
                         {
                              fmt.printf("unbalanced loop ")
                              break mainloop
                         }
                         else if (inp == ']') {
                              depth += 1
                            }
                         else if (inp == '[' && depth != 0) {
                              depth -= 1
                         }
                        //fmt.println(input[i])
                    }

                }
                else {
                    i+=1
                }
            // default: move pointer
           case :
                i +=1

        }

    }

}
