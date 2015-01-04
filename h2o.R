library(caret)
source("./prepareDT.R")

prepareDT(trainDT, "train", limitFactors)
print(str(trainDT))

library(h2o)
localH2O = h2o.init(nthreads=4)

trainDT.h2o <- as.h2o(client = localH2O, trainDT)
print(str(trainDT.h2o))

#train_hex_split <- h2o.splitFrame(trainDT.h2o, ratios = 0.8, shuffle = TRUE)


## Train a 50-node, three-hidden-layer Deep Neural Networks for 100 epochs
model <- h2o.deeplearning(x = 1:(ncol(trainDT.h2o)-1),
                          y = ncol(trainDT.h2o),
                          data = trainDT.h2o,
                          #validation = train_hex_split[[2]],
                          nfolds =5,
                          activation = "Rectifier",
                          hidden = c(10, 10, 10),
                          epochs = 100,
                          classification = TRUE,
                          balance_classes = TRUE, 
                          adaptive_rate = TRUE,
                          epsilon= 1e-10, #c(1e-4, 1e-6, 1e-8, 1e-10),
                          rho = 0.99, #c(0.9, 0.95, 0.99),
                          #l1=c(0, 0.01, 0.1, 1),
                          sparse=FALSE)
print(model)

h2o.saveModel(model, dir=".", name = paste0("model_h2o_", N_rows, "_", model.name, "_lim", limitFactors, ".rda"))

predicted <- as.data.frame(h2o.predict(model, trainDT.h2o))
#what is training error
library(Metrics)
print("training error Final: logLoss")
print(      logLoss( (ifelse(as.matrix(model@data$.outcome)[, 1 ] =="L1", 1, 0)), 
            predicted$L1)                                                            )

#print("ROC curve")
#library(ROCR)
#print( auc(response=mod$trainingData$.outcome, predictor=mod$finalModel$fitted.values)  )
#pr <- prediction(mod$finalModel$fitted.values, mod$trainingData$.outcome)
#plot(performance(pr, "tpr", "fpr"))
#print("AUC is")
#print( performance(pr, "auc")@y.values )
