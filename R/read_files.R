# read in files, but lazy 
## don't need to do this to use downstream scripts 

egi_read_abs <- function(path, protocolname){
  
  # locate files 
  f.list <- list.files(path, full.names = T)
  
  # remove drug printer file 
  f.list <- f.list[-grep(protocolname, f.list)]
  
  # read in files 
  r.list <- lapply(f.list, function(x) read.csv(x, skip = 1, row.names = 1))
  
  # get names 
  names <- unlist(lapply(f.list, function(x) 
    tail(unlist(str_split(x, "/")), n = 1)))
  
  # rm csv suffix
  names <- unlist(lapply(names, function(x) str_split_i(x, "\\.", 1)))
  
  # move to env
  names(r.list) <- names
  
  return(r.list)
}

