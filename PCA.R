# PCA
library(pca)
Neopro <- read.csv(file="c:/Users/user/Desktop/ova.csv", header=TRUE, sep=",") #load data
head(Neopro) #show sample data
dim(Neopro) #check dimensions
str(Neopro) #show structure of the data
sum(Neopro) 
colnames(Neopro)
apply(Neopro,2,var) #check the variance accross the variables
pca =prcomp(Neopro) #applying principal component analysis on crimtab data
par(mar = rep(2, 4)) #plot to show variable importance
plot(pca) 
'below code changes the directions of the biplot, if we donot include
the below two lines the plot will be mirror image to the below one.'
pca$rotation=-pca$rotation
pca$x=-pca$x
biplot (pca , scale =0) #plot pca components using biplot in r
#PLS
#load the plsdepot package and a dataset
library(plsdepot)
data(Neopro)
head(Neopro)
names(Neopro)
class = Neopro[ ,c(1:12,14:16,13)]
pls1 = plsreg1(class[, 1:15], class[, 16, drop = FALSE], comps = 3)
pls1
#R2 for each of our components
pls1$R2
# correlations plot; notice what is highly correlated with class

plot(pls1)



