NB. =========================================================
NB.*ferase v erases a file
NB. Returns 1 if successful, otherwise _1
ferase=: (1!:55 :: _1:) @ (fboxname &>) @ boxopen
