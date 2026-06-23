# function to calculate percent viability from an experimental design and 
# the output from the plate reader for absorbance (I use CCk8 assay)

## plate_absorbance = fed from the output of read_files - just the plate 
### reading in a slightly cleaned up format 

## plate_background = list of wells that are background 

## plate_dmso_block1 = list of wells that are dmso normalized for first block

## plate_dmso_block2 = list of wells that are dmso normalized for second block

egi_percent_viability <- function(plate_absorbance,
                                  plate_background,
                                  plate_dmso_block1,
                                  plate_dmso_block2){
  
  # reshape data for my brain to work with it 
  colnames(plate_absorbance) <- as.character(1:24)
  
  plate <- plate_absorbance %>% 
    rownames_to_column() %>%
    melt(., id.vars = "rowname") %>%
    mutate(cell = paste0(rowname, variable)) %>%
    select(cell, value)
  
  # calculate background absorbance 
  bg <- plate %>% 
    filter(., cell %in% plate_background) %>%
    summarise(mean = mean(value))
  
  # calculate mean DMSO absorbance for block 1 
  dmso.b1 <- plate %>% 
    filter(., cell %in% plate_dmso_block1) %>%
    summarise(mean = mean(value))
  
  # calculate mean DMSO absorbance for block 2
  dmso.b2 <- plate %>% 
    filter(., cell %in% plate_dmso_block2) %>%
    summarise(mean = mean(value))
  
  # write a function to calculate percent viability
  ## (absorbance treated - absorbance background) /
  ## (absorbance of matched DMSO - absorbance background) * 100
  percent.viability <- function(a.t, a.bgf, dmso){
    foo <- ((a.t - a.bgf)/(dmso - a.bgf)) * 100
  }
  
  #run percent viability function
  plate %<>%
    # run on block 1 
    mutate(response = c(unlist(lapply(value[1:192], function(x)
      percent.viability(x, bg, dmso.b1))),
    # run on block 2 
      unlist(lapply(value[193:384], function(x)
        percent.viability(x, bg, dmso.b2)))))
  
  return(plate)
  
}

