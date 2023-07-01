place_kings <- function(brd){
  ###
  #  Function that puts the two kings on the board
  #  and makes sure that they are not adjacent
  ###
  while (TRUE) {
    # generate positions for white and black kings
    rank_white <- sample(1:8, 1) ; file_white <- sample(1:8, 1)
    rank_black <- sample(1:8, 1) ; file_black <- sample(1:8, 1)
    # compute the differences between ranks and files
    diff_vec <- c(abs(rank_white - rank_black), abs(file_white - file_black))
    # if the two kings are not adjacent, place them on the board
    if (sum(diff_vec) > 2 | setequal(diff_vec, c(0,2))) {
      brd[rank_white, file_white] <- "K"
      brd[rank_black, file_black] <- "k"
      break
    }
  }
  return(brd)
}

pawn_on_extreme_ranks <- function(pc, pr){
  ###
  #  Function that checks whether a pawn is on the first or eight rank
  #  (such a situation is not possible in chess)
  ###
  if (pc %in% c("P","p") & pr %in% c(1,8))
    return(TRUE)
  else
    return(FALSE)
}

populate_board <- function(brd, wp, bp){
  ###
  #  Function that puts pieces on the board making sure that they
  #  are not on the same squares, and verifying for pawn_on_extreme_ranks
  ###
  # initialization
  piece_list <- c("P", "N", "B", "R", "Q")
  for (color in c("white", "black")){
    # iterate for white (first) and black (after) pieces
    if (color == "white"){
      n_pieces = wp
      pieces = piece_list
    }
    else {
      n_pieces = bp
      pieces = tolower(piece_list)
    }
    # place pieces one by one until we have them
    while (n_pieces != 0){
      piece_rank <- sample(1:8, 1) ; piece_file <- sample(1:8, 1)
      piece <- sample(pieces, 1)
      # check if square is empty and it is not a pawn on an extreme rank
      if (brd[piece_rank, piece_file] == " " & !pawn_on_extreme_ranks(piece, piece_rank)){
        brd[piece_rank, piece_file] <- piece
        n_pieces <- n_pieces - 1
      }
    }
  }
  return(brd)
}

fen_from_board <- function(brd){
  ###
  #  Function that prints out the FEN of a given input board
  ###
  # create vector of positions by row
  fen <- apply(brd, 1, function(x) {
    r <- rle(x)
    paste(ifelse(r$values == " ", r$lengths, r$values), collapse = "")
    })
  # paste them together with separator '/' and add the final string
  fen <- paste(paste(fen, collapse = "/"), "w - - 0 1")
  return(fen)
}

generate_fen <- function(){
  ###
  #  This function calls all the functions above and generates
  #  the board representation along with its FEN
  ###
  # initialization
  board <- matrix(" ", nrow = 8, ncol = 8)
  # generate random amount of white and black pieces (kings excluded)
  n_pieces_white <- sample(0:31, 1) ; n_pieces_black <- sample(0:31, 1)
  # place kings on board
  board <- place_kings(board)
  # put other pieces on board
  board <- populate_board(board, wp = n_pieces_white, bp = n_pieces_black)
  # print board and FEN
  print(board)
  cat("\n")
  cat(fen_from_board(board))
}

generate_fen()
