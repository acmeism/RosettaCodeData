  is_dir_empty <- function(path){
    if(length(list.files(path)) == 0)
      print("This folder is empty")
  }

  is_dir_empty(path)
