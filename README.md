# Welcome to synergize! 

If you're here, you may be working on synergy datasets from a "drug printer."  
Hope this helps! 

In our workflow, cells are plated in 384 well plates, with two blocks - where 
synergy with Drug 2 is assessed in both blocks usually against two unique drugs, 
one in each block. Cells are treated 24 hours after plating, and are read out 
after 48 hours. Viability is calculated using absorbance from a CCK-8 (formazin)
assay read at 450 nm 6 hours after treatment with CCK-8. 

### Read Files 
Optional script - if you're loading many csv absorbance files into your 
environment, this guy can help you out. 

use 
'''
egi_read_ab()
'''

### Process Protocol 


use 
'''
egi_read_prot
'''

### Calculate Percent Viability


use 
'''
egi_percent_viability 
'''

### Align Data 


use 
'''
egi_align_synergy
'''

### Plot Data 


use 
'''
egi_plot_this
'''


