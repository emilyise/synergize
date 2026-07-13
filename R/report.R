
egi_generate_report <- function(image_folder, 
                                cell_order, 
                                output_pdf = paste0(image_folder,
                                                    "/Synergy_Report.pdf"),
                                grid_panel_size = "x800"){
  
  # get files 
  f.list <- list.files(image_folder, pattern = "\\.png$", full.names = TRUE)
  
  # get info from files 
  f.data <- data.frame(full_path = f.list, stringsAsFactors = FALSE)
  f.data$base_name <- basename(f.data$full_path)
  
  parts <- str_split_fixed(str_remove(f.data$base_name, "\\.png$"), "_", 3)
  
  f.data %<>%
    mutate(type = parts[,1],
           cell_line = parts[,2],
           combo = parts[,3]) %>%
    filter_out(type == "DrugBars") %>%
    filter_out(type == "Synergy")

  
  # sort on desired plot seq 
  f.data %<>% 
    arrange(factor(cell_line, levels = cell_order))
  f.data <- f.data[order(c(f.data$combo)), ]
  
  # create a key 
  f.data$group_key <- paste(f.data$combo, f.data$cell_line, sep = " — ")
  
  # make grid assignments 
  group_factor <- factor(f.data$group_key, levels = unique(f.data$group_key))
  groups <- split(f.data, group_factor)
  
  pdf_pages <- map(names(groups), function(group_name) {
    sub_df <- groups[[group_name]]
    
    # sort for consistent mapping
    sub_df %<>%
      arrange(factor(type, levels = c("DoseResponse", "2DSynergy")))
    
    # read plot images
    imgs <- image_read(sub_df$full_path)
    
    # generate clean top section header banner
    title_canvas <- image_blank(width = 800, height = 80, color = "white") %>%
      image_annotate(text = group_name, size = 32, weight = 700, gravity = "center", color = "black")
    
    # build the image grid
    grid <- image_montage(imgs, geometry = grid_panel_size)
    grid <- image_trim(grid)
    
    # append the text title to the top of the grid canvas
    page <- image_append(c(title_canvas, grid), stack = TRUE)
    return(page)
  })
  
  # bind pages together and compile the PDF 
  final_report <- image_join(pdf_pages)
  image_write(final_report, format = "pdf", path = output_pdf)
}
