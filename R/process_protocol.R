# function to process a protocol for the drug printer 
## the drug printer protocols are bulky and they have extremely specific
## dispense volumes, so any float digits at the end of these numbers 
## is a problem for the matrix needed to run the synergy analysis step

## ss.protocol = raw synergy screen protocol from the drub printer 
### (well raw ish, I delete the very top few rows before loading in )

## n.plates = the number of plates used for the experiment
## cell.lines <- the cell lines used IN ORDER
### this assumes that if you used LINE1 and LINE2 on four plates, the plates
### were run as LINE1 LINE1 LINE2 LINE2 (this could def be fixed down the line
### to read straight from the protocol metadata but it couldn't be me right now)

egi_read_prot <- function(ss.protocol, n.plates, cell.lines){
  
  # minor changes for data manip
  ss.protocol <- as.data.frame(ss.protocol)
  ss.protocol <- ss.protocol[,-1]
  
  # remove empty top section 
  index <- grep("Plate", ss.protocol$V2)[2]
  colnames(ss.protocol) <- ss.protocol[index,]
  ss.protocol <- ss.protocol[-c(1:(index)),]  
  
  # remove excess bottom section 
  index <- which(is.na(ss.protocol[,1]))[1]
  ss.protocol <- ss.protocol[-c(index:nrow(ss.protocol)),]
  rownames(ss.protocol) <- c(1:nrow(ss.protocol))
  
  # get rid of empty columns 
  index <- which(is.na(colnames(ss.protocol)))
  ss.protocol <- ss.protocol[,-c(index)]
  
  # pre-process protocol for use in analyses
  # just tidying up // resolving classes for downstream
  ss.protocol %<>%
    mutate(`Dispensed concentration` = as.numeric(`Dispensed concentration`))
  colnames(ss.protocol) <- gsub(" ", "\\.", colnames(ss.protocol))
  colnames(ss.protocol) <- gsub("-", "\\.", colnames(ss.protocol))
  
  # add cell line names to plate number for downstream alignment
  ## get the number of times each cell line is repeated (plates per cell line)
  reps <- n.plates/length(cell.lines)
  my.order <- unlist(lapply(cell.lines, function(x) rep(x, reps)))
  
  # align the cell lines to the plate numbers
  ## wow i would never do it like this these days but it works so i'm not 
  ## touching it hah
  for (i in seq_along(my.order)){
    ss.protocol$cell.line[ss.protocol$Plate == i] <- my.order[i] 
  }
  
  # fix concentrations to match undiluted stock (? maybe ? )
  ## and remove dilutions from drug names 
  for (i in grep(" - ", ss.protocol$Fluid.name)){
    # get the dilution factor
    dil.fac <- as.numeric(str_split_1(ss.protocol$Fluid.name[i], ":")[2])
    # factor into concentration for undiluted drug
    ss.protocol$Dispensed.concentration[i] <- ss.protocol$Dispensed.concentration[i] * dil.fac
    # remove the dilutions from the drug names
    ss.protocol$Fluid.name[i] <- str_split_1(ss.protocol$Fluid.name[i], " -")[1]
  }
  
  # is changing the fluid name part of the issue ?? or what ? 
  
  ### resolve dispensed concentration float (tecan records precise dispensation)
  for (foo in cell.lines){
    cellset <- ss.protocol[ss.protocol$cell.line == foo,]
    for (i in unique(cellset$Fluid.name)){ # for each fluid
      set <- cellset[cellset$Fluid.name == i,] # subset the protocol
      if (unique(set$Fluid.name) != "DMSO normalization"){
        for (j in unique(set$Dispensed.volume)){ #and for each volume
          subset <- set[which(set$Dispensed.volume == j),] #subset the protocol
          value <- median(subset$Dispensed.concentration) #to find the median dispensed
          index <- which(ss.protocol$Fluid.name == i &
                           ss.protocol$Dispensed.volume == j &
                           ss.protocol$cell.line == foo)
          ss.protocol$Dispensed.concentration[index] <- value 
        } 
      } else {}
    }
  }

  
  return(ss.protocol)
  
}