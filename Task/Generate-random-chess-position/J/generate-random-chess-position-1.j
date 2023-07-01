getlayout=:3 :0
  whilst. NB. first two positions are non-adjacent kings
    (0{pos) e. (1{pos)+(,-)1 7 8 9
  do.
    pos=: y?64
  end.
)

randboard=:3 :0
  n=: ?30  NB. number of non-king pieces on board
  layout=: getlayout 2+n   NB. where they go
  white=: 0 1,?n#2         NB. which ones are white?
  pawns=: 0 0,?n#2             NB. where are the pawns?
  pawns=: pawns * 1- white*layout e.56+i.8
  pawns=: pawns * 1-(1-white)*layout e.i.8
  ptyp=: 'pkqbjnPKQBJN'{~(6*white)+1 1,(1-2}.pawns)*2+?n#4
  8 8$ptyp layout}64#'.'
)

NB. fen compress a line
fen1=:3 :0
  for_n.8-i.8 do.
    y=. y rplc (#&'.';":) n
  end.
)

NB. translate 8x8 board to fen notation
NB. (just the task specific crippled fen)
b2fen=:3 :0
  (}.;|.<@(('/',fen1)"1) y),' w - - 0 1'
)

randfen=:b2fen@randboard
