library(MASS)
library(tidyverse)
library(ROCR)
library(caret)
library(glmnet)
library(doParallel)
library(foreach)
library(pROC)


rm(list=ls())

# Read in data
data <- read_delim("digiwest.csv", ";", escape_double = FALSE, trim_ws = TRUE)
data <- data %>% select(-sampleID)
data[,"y"] <- ifelse(data[,"Class  var"] == "Cancer",1,0)
data <- data %>% select(-"Class  var")
y <- data["y"]
data <- data %>% select(-y)
data <- cbind(y,data)
data <- data %>% select(-UNC45A  # 2446)

# Remove space in variable names
temp_colnames <- gsub(" ", "",colnames(data))
colnames(data) <- temp_colnames

# class label must be factor 0 noevent, 1:anomalous
digiwest$Class  var<-ifelse(digiwes$Class  var=="Non-cancer",0,1)
#data$Cardio1M=factor(data$Cardio1M)
#split data into train and test
trainIndex <- createDataPartition(digiwest$Class  var, p=0.7, list=FALSE)
data_train <- iris[ trainIndex,]
data_test <- iris[-trainIndex,]
x.train <- data.matrix (data_train [ ,1:ncol(data_train)-1])
y.train <- data.matrix (data_train$Species)
x.test <- data.matrix (data_test [,1:(ncol(data_test))-1])
y.test <- data.matrix(data_test$Species)
#fitting generalized linear modelalpha=0 then ridge regression is used, while if alpha=1 then the lasso
# of ?? values (the shrinkage coefficient)
#Associated with each value of ?? is a vector of regression coefficients. For example, the 100th value of ??, a very small one, is closer to perform least squares:
Lasso.mod <- glmnet(x.train, y.train, alpha=1, nlambda=100, lambda.min.ratio=0.0001,family="binomial")
#use 10 fold cross-validation to choose optimal ??.
set.seed(1)
#cv.out <- cv.glmnet(x, y, alpha=1,family="binomial", nlambda=100, lambda.min.ratio=0.0001,type.measure = "class")
cv.out <- cv.glmnet(x.train, y.train, alpha=1,family="binomial", nlambda=100, type.measure = "class")
#Ploting the misclassification error and the diferent values of lambda
plot(cv.out)
best.lambda <- cv.out$lambda.min
best.lambda
co<-coef(cv.out, s = "lambda.min")
#Once we have the best lambda, we can use predict to obtain the coefficients.
p<-predict(Lasso.mod, s=best.lambda, type="coefficients")[1:6, ]
p