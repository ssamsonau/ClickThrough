library(caret)
source("./prepareDT.R")

prepareDT(trainDT, "train", limitFactors)
print(str(trainDT))

library(h2o)
localH2O = h2o.init(nthreads=-1)

trainDT.h2o <- as.h2o(client = localH2O, trainDT, header=T)
print(str(trainDT.h2o))

print("training a model")

## Train a 50-node, three-hidden-layer Deep Neural Networks for 100 epochs
grid_search <- h2o.deeplearning(x = 2:ncol(trainDT.h2o),
                          y = 1,
                          data = trainDT.h2o,
                          #validation = train_hex_split[[2]],
                          nfolds = 5,
                          hidden=list(c(20,20)),
                          epochs = 60,
                          activation=c("Tanh", "Rectifier"),
                          classification = TRUE,
                          balance_classes = FALSE, 
                          adaptive_rate = TRUE,
                          epsilon= c(1e-4, 1e-6, 1e-8, 1e-10),
                          rho = c(0.9, 0.95, 0.99),
                          #l2=c(1e-5, 1e-4),
                          #l1=c(0, 1e-5),
                          fast_mode=TRUE
                          )

best_model <- grid_search@model[[1]]

best_params <- best_model@model$params

print(best_model)
print(best_params)

#h2o.saveModel(model, dir=".", name = paste0("model_h2o_", model.name, "_lim", limitFactors, ".rda"))

predicted <- as.data.frame(h2o.predict(best_model, trainDT.h2o))
#what is training error
library(Metrics)
print("training error Final: logLoss")
print(      logLoss( (ifelse(as.matrix(best_model@data$click)[, 1 ] =="L1", 1, 0)), 
            predicted$L1)                                                            )

