# function to align percent viability data with the protocol data 

# cell_line <- "A673"
# plate_pv <- pvs[[1]]
# protocol <- prot 
# background <- bgs[[1]]
# z_b1 <- b1_zero
# z_b2 <- b2_zero

egi_align_synergy <- function(cell_line, plate_pv, protocol, background, 
                              z_b1, z_b2){
  
  # make naming conventions for cell match for alignment 
  split <- str_split(plate_pv$cell, "")
  for (i in seq_along(split)){
    if (length(split[[i]]) == 2){
      split[[i]][3] <- split[[i]][2]
      split[[i]][2] <- "0"
      split[[i]] <- str_flatten(split[[i]])
    } else {
      split[[i]] <- str_flatten(split[[i]])
    }
  }
  
  # add the output to a new column 
  plate_pv %<>% 
    mutate(cell = unlist(split))
  
  # pivot protocol wider
  ## and subset to cell line 
  protocol %<>%
    filter(cell.line == cell_line) %>%
    mutate(Non.random.col = as.numeric(Non.random.col),
           block_id = ifelse(Non.random.col < 12, 1, 2),
           cell = Dispensed.well) %>%
    select(cell.line, block_id, cell, Fluid.name, Dispensed.concentration,
           Conc..units) %>%
    filter(Fluid.name != "DMSO normalization") %>%
    group_by(cell.line, block_id, cell) %>%
    mutate(fluid_num = row_number()) %>%
    ungroup() %>%
    pivot_wider(
      id_cols = c(cell.line, block_id, cell, Conc..units),
      names_from = fluid_num,
      values_from = c(Fluid.name, Dispensed.concentration),
      names_glue = "{.value}{fluid_num}"
    )
  
  # append the response to the protocol 
  protocol  %<>%
    left_join(., plate_pv, by = "cell") %>%
    select(block_id, Conc..units, Fluid.name1, Fluid.name2, 
           Dispensed.concentration1,Dispensed.concentration2, response)
  
  colnames(protocol) <- c("block_id", "conc_unit", 
                          "drug1", "drug2", "conc1", "conc2", "response")

  # but there are some issues, so fix it quick 
  ## for cells that only received drug 2, move to drug 2 and conc 2
  drug.two <- unique(na.omit(protocol$drug2))
  
  for(i in which(protocol$drug1 == drug.two)){
    protocol$drug2[i] = protocol$drug1[i]
    protocol$conc2[i] = protocol$conc1[i]
    protocol$drug1[i] = NA
    protocol$conc1[i] = 0
  }
  
  ## for cells that only received drug 1, add drug 2 and conc 3 
  for(i in which(is.na(protocol$drug2))){
    protocol$drug2[i] = drug.two
    protocol$conc2[i] = 0
    }
  
  ## for cells that only received drug 2, add drug 1 for block 1 
  drug.one <- unique(na.omit(protocol$drug1[which(protocol$block_id == 1)]))
  
  for(i in which(protocol$block_id == 1 & is.na(protocol$drug1))){
    protocol$drug1[i] = drug.one
  }
  
  ### add the 0 drug well in the matrix in block 1 
  z_add <- plate_pv %>% filter(cell == z_b1)
  z_add <- z_add$response
  z_add <- list("block_id" = 1,
                "conc_unit" = "uM", 
                "drug1" = drug.one, 
                "drug2" = drug.two, 
                "conc1" = 0, 
                "conc2" = 0 , 
                "response" = z_add)
  
  protocol <- rbind(protocol, z_add)
  
  ## for cells that only received drug 2, add drug 1 for block 2
  drug.one <- unique(na.omit(protocol$drug1[which(protocol$block_id == 2)]))
  
  for(i in which(protocol$block_id == 2 & is.na(protocol$drug1))){
    protocol$drug1[i] = drug.one
  }
  
  ### add the 0 drug well in the matrix in block 2
  z_add <- plate_pv %>% filter(cell == z_b2)
  z_add <- z_add$response
  z_add <- list("block_id" = 2,
                "conc_unit" = "uM", 
                "drug1" = drug.one, 
                "drug2" = drug.two, 
                "conc1" = 0, 
                "conc2" = 0 , 
                "response" = z_add)
  
  protocol <- rbind(protocol, z_add)
  
  return(protocol)
  
}