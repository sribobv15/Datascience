MyData <- read.csv(file="c:/Users/user/Desktop/sample1.csv", header=TRUE, sep=",")
tmp.data = MyData[, -5]
tmp.group = MyData[, 5]  # species
tmp.y = matrix(as.numeric(tmp.group), ncol = 1)  # make numeric matrix

#The data will be split into 1/3 test and 2/3 trainning sets. The trainning data will be used for:
  #model optimization
#permutation testing
#internaly cross-validated estimate of trainning and out-of-bag error (OOB)

#The hold out set or the test data will be used to estimate the externally validated OOB.

#Generate external test set using the duplex or kennard stone method.
library(caret)
train.test.index.main = (nrow(tmp.data) n = 1 strata = tmp.group
                                         split.type = "duplex" data = tmp.data)
train.id = train.test.index.main == "train"

# partition data to get the trainning set
tmp.data = tmp.data[train.id, ]
tmp.group = tmp.group[train.id]
tmp.y = tmp.y[train.id, ]

# the variables could be scaled now, or done internally in the model for
# each CV split (leave-one-out)
# scaled.data = data.frame(scale(tmp.data,center=TRUE, scale=TRUE))
scaled.data  = tmp.data

#Train O-PLS-DA model
#Compare a 2 latent variable (LV) PLS-DA and 2 LV with one orthogonal LV (OSC LV or OLV) O-PLS-DA model.

mods = make.OSC.PLS.model(tmp.y, pls.data = scaled.data, comp = 2, OSC.comp = 1, 
                          validation = "LOO", method = "oscorespls", cv.scale = TRUE, progress = FALSE)
# extract model
final = get.OSC.model(obj = mods, OSC.comp = 1)
# view out-of-bag error for cross-validation splits
plot.OSC.results(mods, plot = "RMSEP", groups = tmp.group)