# Welcome to synergize! 

If you're here, you may be working on synergy datasets from a "drug printer."  
Hope this helps! 

In our workflow, cells are plated in 384 well plates, with two blocks - where 
synergy with Drug 2 is assessed in both blocks usually against two unique drugs, 
one in each block. Cells are treated 24 hours after plating, and are read out 
after 48 hours. Viability is calculated using absorbance from a CCK-8 (formazin)
assay read at 450 nm 6 hours after treatment with CCK-8. 

## Read Files 
Optional script - if you're loading many csv absorbance files into your 
environment, this guy can help you out. 

use 
```
egi_read_ab()
```

## Process Protocol 
Use this function to read in and clean up your protocol as generated from the
drug printer for downstream analysis. Requires the top few lines above the first
table with rownames to be deleted. Takes the median value of each concentration
(based on dispensed volume) to resolve float digits. Each concentration much
match exactly to form a matrix or values will be imputed downstream. 

use 
```
egi_read_prot()
```

## Calculate Percent Viability
As simple as it sounds. Calculate percent viability from absorbance data. 

use 
```
egi_percent_viability()
```

## Align Data 
Function to align percent viability and protocol into the format required by
SynergyFinder.

use 
```
egi_align_synergy()
```

## Plot Data 
And finally, plot the data! This will produce 2D synergy plots, dose response 
plots, synergy bar plots, and a ZIP synergy score matrix for each drug 
combination. 

use 
```
egi_plot_this()
```



