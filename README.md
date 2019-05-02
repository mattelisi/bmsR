
# bmsR
R package for doing Bayesian model comparison at the group level, treating the model as random effect.

See Stephan, Penny, Daunizeau, Moran, and Friston (2009). Bayesian model selection for group studies. _NeuroImage, 46_(4):1004–1017. Also, this [blog post](https://mattelisi.github.io/post/bms/)

This implementation has been translated from SPM 12, a toolbox for matlab used in the analysis of neuroimaging data.

If you want to use it, to install type in R terminal:
```R
library(devtools)
install_github("mattelisi/mlisi") # required for some dependancies
install_github("mattelisi/bmsR")
```

Here is an example
```R
# input some example data, a matrix [N-by-K] of model evidences
# where N is the number of subjects and K the number of models
# (here we have 12 participants and 6 models)
m <- structure(c(2.50809867187394e-22, 0.000146611855314775, 4.58668624689671e-25, 4.10535400464176e-07, 0.0686634208305935, 0.0367833971579169, 0.000110346493359948, 1.68129802885811e-08, 0.108275519613786, 3.9578164134093e-11, 0.0367837099909541, 1.08999881504e-07, 0.0343412062159018,  0.00446326510403562, 0.00172330666747482, 0.000990826155243488,  0.158393579220946, 0.0295386936257688, 0.00012552265085804, 0.0272190104668559, 0.0530936016907313, 2.07255371227757e-10, 0.0214823528123676,   4.73437495302293e-05, 0.677938621542126, 5.20954432898137e-08,  0.000627393517771912, 0.000388486329012404, 3.17565869877651e-18,  0.191176500286399, 3.83899865682068e-07, 0.0619217494201652,   0.559188952807853, 5.06676447796227e-09, 0.0418921682773635,  0.702014475355336, 0.249399681241455, 0.862817395918837, 0.864775715064725,  0.865617369930796, 0.147322698727657, 0.643610120435765, 0.866608545004982,   0.789544918511435, 0.207285291019464, 0.866813333179825, 0.779961587662899,  0.258256692887969, 0.0337525764999333, 0.116769634805204, 0.117034665657295,   0.11714857188609, 0.497854787795748, 0.0871031579431148, 0.117282712780637,   0.106853285174707, 0.0635553531488496, 0.117310426702891, 0.105556322380037,   0.0349512426797482, 0.00456791450058339, 0.0158030402211649,  0.0158389190927326, 0.0158543351634575, 0.127765513425055, 0.0117881305510349, 0.0158724891702976, 0.0144610196138568, 0.00860128171931599,  0.0158762348036855, 0.0143238588763795, 0.00473013632753477), .Dim = c(12L, 6L), .Dimnames = list(c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"), c("M1", "M2", "M3", "M4", "M5", "M6")))

# load the library
library(bmsR)

# the model evidences above sum to 1 for each participants
# (they are the Akaike weights from a yet unpublished study)
# so we convert them into log model evidences
m <- log(m)

# run model selection procedure
# VB_bms() is the main function of the package
bms0 <- VB_bms(m)
```

Results:
```R
> # the code output a structure with fields
> names(bms0)
[1] "alpha" "r"     "xp"    "bor"   "pxp"
> 
> # Dirichlet parameters
> bms0$alpha
[1]  1.043623  1.064976  1.720754 11.835847  1.290641  1.044160
> 
> # model frequencies
> bms0$r
[1] 0.05797903 0.05916533 0.09559743 0.65754706 0.07170226 0.05800889
> 
> # exceedance probabilities 
> bms0$xp
[1] 0.000279 0.000319 0.001173 0.997441 0.000514 0.000274
> 
> # Bayesian omnibus risk (i.e. probability that model differences are due to chance)
> bms0$bor
[1] 0.002890379
> 
> # protected exceedance probabilities
> bms0$pxp
[1] 0.0007599235 0.0007998079 0.0016513395 0.9950397470 0.0009942442
[6] 0.0007549379
```


