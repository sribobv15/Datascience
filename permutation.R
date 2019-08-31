Neopro <- read.csv(file="c:/Users/user/Desktop/ova.csv", header=TRUE, sep=",") #load data
### Summarize data

library(FSA)

Summarize(Length ~ Hand, 
          data=Neopro, 
          digits=3)