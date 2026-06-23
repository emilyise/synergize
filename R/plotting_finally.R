# function to make a thousand plots from our data whoooo 

egi_plot_this <- function(proj, cell_lines, drug_combos, res_list){
  for(i in seq_along(cell_lines)){
    for(j in seq_along(drug_combos)){
      
      # Plot Dose Response 
      png(paste0("../figures/", proj, "/DoseResponse_", cell_lines[i], "_", drug_combos[j], ".png"),
          width = 1500, height = 900)
       PlotDoseResponse(
        data = res_list[[i]],
        block_ids = j,
        drugs = c(1, 2),
        save_file = TRUE,
        file_type = "png",
        file_name = paste0("../figures/", proj, "/DoseResponse_", cell_lines[i], "_", drug_combos[j])
      )
      dev.off()
      
      png(paste0("../figures/", proj, "/DoseResponse_", cell_lines[i], "_", drug_combos[j], ".png"),
          width = 1500, height = 900)
      PlotDoseResponse(
        data = res_list[[i]],
        block_ids = j,
        drugs = c(1, 2),
        save_file = TRUE,
        file_type = "png",
        file_name = paste0("../figures/", proj, "/DoseResponse_", cell_lines[i], "_", drug_combos[j])
      )
      dev.off()
      
      # Plot Synergy
      png(paste0("../figures/", proj, "/Synergy_", cell_lines[i], "_", drug_combos[j], ".png"))
      PlotSynergy(
        data = res.list[[i]],
        block_ids = j,
        drugs = c(1, 2),
        save_file = TRUE,
        file_type = "png",
        file_name = paste0("../figures/", proj, "/Synergy_", cell_lines[i], "_", drug_combos[j])
      )
      dev.off()
      
      png(paste0("../figures/", proj, "/Synergy_", cell_lines[i], "_", drug_combos[j], ".png"))
      PlotSynergy(
        data = res.list[[i]],
        block_ids = j,
        drugs = c(1, 2),
        save_file = TRUE,
        file_type = "png",
        file_name = paste0("../figures/", proj, "/Synergy_", cell_lines[i], "_", drug_combos[j])
      )
      dev.off()
      
      
      # Plot 2D Surface
      png(paste0("../figures/", proj, "/2DSynergy_", cell_lines[i], "_", drug_combos[j], ".png"))
      Plot2DrugSurface(
        data = res.list[[i]],
        plot_block = j,
        drugs = c(1, 2),
        plot_value = "ZIP_synergy",
        dynamic = FALSE,
        summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
      )
      dev.off()
      
      png(paste0("../figures/", proj, "/2DSynergy_", cell_lines[i], "_", drug_combos[j], ".png"))
      Plot2DrugSurface(
        data = res.list[[i]],
        plot_block = j,
        drugs = c(1, 2),
        plot_value = "ZIP_synergy",
        dynamic = FALSE,
        summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
      )
      dev.off()
      
      
      # Plot Multi-Drug Bar
      PlotMultiDrugBar(
        data = res.list[[i]],
        plot_block = j, 
        plot_value = c("response", "ZIP_synergy", 
                       "Loewe_synergy", "HSA_synergy", "Bliss_synergy"),
        sort_by = "response",
        highlight_label_size = 8)
      ggsave(paste0("../figures/", proj, "/DrugBars_", cell_lines[i], "_", drug_combos[j],
                    ".png"), bg = "white", height = 12, width = 12)
      
      PlotMultiDrugBar(
        data = res.list[[i]],
        plot_block = j, 
        plot_value = c("response", "ZIP_synergy", 
                       "Loewe_synergy", "HSA_synergy", "Bliss_synergy"),
        sort_by = "response",
        highlight_label_size = 8)
      ggsave(paste0("../figures/", proj, "/DrugBars_", cell_lines[i], "_", drug_combos[j],
                    ".png"), bg = "white", height = 12, width = 12)
      
    }
  }
}

