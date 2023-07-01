Note 'snusp'

    Without $ character the program counter starts at top left (0 0) moving to the right (0 1)

    >       increment the pointer (to point to the next cell to the right).
    <       decrement the pointer (to point to the next cell to the left).
    +       increment (increase by one) the cell at the pointer.
    -       decrement (decrease by one) the cell at the pointer.
    .       output the value of the cell at the pointer as a character.
    ,       accept one character of input, storing its value in the cell at the pointer.
    \/      mirrors
    ?       skip if memory pointer is 0
    !       skip
    $       optional start program here (also heading to the right)

)

smoutput 'Toroidal programs run forever.  Use ^C to interrupt.'

main =: 3 : 0  NB. use: main 'program.snusp'
 PROGRAM =: [;._2 LF ,~ 1!:1 boxopen y
 SHAPE =: $PROGRAM
 PC =: SHAPE#:(,PROGRAM) i.'$'
 PCSTEP =: 0 1
 CELL =: 0
 CELLS =: ,0
 while. 1 do. NB. for_i. i.400 do.
  INSTRUCTION =: (<PC) { PROGRAM
  STEP =: PCSTEP
  select. INSTRUCTION
  case. '<' do.
   CELL =: <: CELL
   if. CELL < 0 do.
    CELL =: 0
    CELLS =: 0 , CELLS
   end.
  case. '>' do.
   CELL =: >: CELL
   if. CELL >: # CELLS do.
    CELLS =: CELLS , 0
   end.
  case. ;/'-+' do. CELLS =: CELL ((<:'- +'i.INSTRUCTION)+{)`[`]} CELLS
  case. '.' do. 1!:2&4 (CELL{CELLS){a.
  case. ',' do. CELLS =: (1!:1<1) CELL } CELLS
  fcase. '/' do. STEP =: - STEP
  case. '\' do. STEP =: PCSTEP =: |. STEP
  case. '?' do. STEP =: +:^:(0 = CELL{CELLS) STEP
  case. '!' do. STEP =: +: STEP
  end.
  PC =: (| (PC + STEP + ])) SHAPE  NB. toroidal
  NB. smoutput PC;CELL;CELLS  NB. debug
 end.
)
