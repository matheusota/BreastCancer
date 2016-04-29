# author: Matheus Jun Ota

setwd("~/ML/Project")

#Load libraries
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(randomForest)
library(party)
library(ROCR)
library(ggplot2)

#Set a seed for randomness
set.seed(415)

#Import whole data
cancerData <- read.csv("~/ML/Project/cancerData/wdbc.data")

#Randomly shuffle data
cancerData <- cancerData[sample(nrow(cancerData)),]

#Create 10 folds
folds <- cut(seq(1,nrow(cancerData)),breaks=10,labels=FALSE)

acc <- c()
auc <- c()

for(i in 1:10){
  #Segment data
  testIndexes <- which(folds==i,arr.ind=TRUE)
  test <- cancerData[testIndexes, ]
  train <- cancerData[-testIndexes, ]
  
  #Create a Decision Tree
  fit <- rpart(Diagnosis ~ Radius1 + Texture1 + Perimeter1 + Area1 + Smoothness1 + Compactness1 + Concavity1 + ConcavePoints1 + Symmetry1 + FractalDimension1, 
   data=train,method="class")
  #fit <- rpart(Diagnosis ~ ., data=train,method="class")
  
  #Create a Decision Forest
  #fit <- randomForest(Diagnosis ~ Radius1 + Texture1 + Perimeter1 + Area1 + Smoothness1 + Compactness1 + Concavity1 + ConcavePoints1 + Symmetry1 + FractalDimension1, 
  # data=train, importance=TRUE, ntree=100)
  
  #Plot
  fancyRpartPlot(fit)
  
  #Create a predict vector
  pred <- predict(fit, newdata=test[,-2], type="prob")[,2]
  pred1 <- predict(fit, test[,-2], type="class")
  pred2 <- prediction(pred, test$Diagnosis) 
  
  #Compare with true classes and update accuracy and area under roc curve
  acc <- c(acc, mean(pred1 == test$Diagnosis))
  perf <- performance(pred2, "tpr", "fpr")
  auc1 <- performance(pred2,"auc")
  auc1 <- unlist(slot(auc1, "y.values"))
  auc <- c(auc, auc1)
  
  tab = table (pred1, test$Diagnosis)
  print(tab)
  
  #if(i == 1){
  #  plot(perf, lwd=2, col="blue")
  #}
  #else{
  #  plot(perf, add = TRUE, col="blue")
  #}
}

#print final result
varImpPlot(fit)
mean(acc)
mean(auc)