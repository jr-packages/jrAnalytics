# library(caret)
# data(diamonds,package = "ggplot2")
#
# diamonds = diamonds[1:1000,]
#
# m = train(price~carat + x + I(x^2), data= diamonds, method = "lm")
#
# f = function(model, xvar = NULL, yvar = NULL, points = TRUE,...){
#   if(!inherits(model, "train")){
#     stop("This function is only applicable for models fit using caret::train")
#   }
#   dots = list(...)
#   dot_names = names(dots)
#   # if(is.null(dot_names)) dot_names = ""
#   if(length(dots) > 0){
#     dot_names = names(dots)
#     dot_names = dot_names[dot_names %in% rhs]
#   }
#   if(!is.null(xvar)){
#     xvar = as.character(substitute(xvar))
#   }
#   if(!is.null(yvar)){
#     yvar = as.character(substitute(yvar))
#   }
#   # print(xvar,yvar)
#   tdata = model$trainingData[,-1,drop=FALSE]
#   which_num = sapply(tdata,is.numeric)
#   rhs = all.vars(formula(model))[-1] # drop the outcome
#
#   if(length(rhs) < 2){
#     stop("We need at least 2 numeric predictors to generate a 3d surface")
#   }
#   if(is.null(xvar)){
#     message("xvar not specified, defaulting to the first available numeric variable in the formula")
#     xvar = setdiff(names(which(which_num)),dot_names)[1]
#     if(!is.null(yvar) && xvar == yvar){ #implies yvar was set to first var in formula
#       xvar = setdiff(names(which(which_num)),dot_names)[2]
#     }
#   }
#   if(is.null(yvar)){
#     message("yvar not specified, defaulting to first available numeric variable in the formula")
#     yvar = setdiff(names(which(which_num)),dot_names)[1]
#     if(xvar == yvar){ #implies xvar was set to first var in formula
#       yvar = setdiff(names(which(which_num)),dot_names)[2]
#     }
#   }
#
#   # here xvar and yvar are now names of variables used in the model fit
#   if(!all(c(xvar,yvar) %in% rhs)){
#     stop("Either xvar or yvar was set to a variable that was not used in fitting the model")
#   }
#   if(! (is.numeric(tdata[[xvar]]) & is.numeric(tdata[[yvar]]))){
#     stop("Either xvar or yvar are not numeric")
#   }
#   if(length(rhs) > 2){
#
#
#     warning("Taking the average of the unset predictors for creating the surface.")
#     extravar = setdiff(rhs,c(xvar,yvar,dot_names))
#     extras = lapply(tdata[,extravar,drop=FALSE], function(x){
#       if(is.numeric(x)) mean(x)
#       else{
#         names(which.max(table(x)))
#       }
#     })
#   }
#   if(length(dot_names) > 0){
#     pred_data = data.frame(extras, dots[dot_names])
#   }else{
#     pred_data = data.frame(extras)
#   }
#
#   xrange = range(tdata[xvar])*c(0.95,1.05)
#   yrange = range(tdata[yvar])*c(0.95,1.05)
#   x = seq(min(xrange), max(xrange), length.out = 100)
#   y = seq(min(yrange),max(yrange), length.out = 100)
#   z = outer(x, y, function(i, j) {
#     df = cbind(pred_data, setNames(list(i, j),c(xvar,yvar)))
#     # names(df) = all.vars(formula(model))[2:3]
#     predict(model, df)
#   })
#   print(c(xvar,yvar))
#
#   p = plot_ly(x=~x,y=~y,z = ~z) %>%
#     add_surface() %>%
#     layout(xaxis = list(title = xvar),yaxis = list(title = yvar))
#
#   if(points){
#     df = model$trainingData
#     names(df)[names(df) == ".outcome"] = "response"
#     names(df)[names(df) == xvar] = "xx1"
#     names(df)[names(df) == yvar] = "xx2"
#     p %>% add_trace(data = df, x = ~xx1, y = ~xx2, z = ~response, mode = "markers", type = "scatter3d",
#                     marker = list(size = 5, color = "red", symbol = 104))
#   }
#
#   print(p)
#   invisible(z)
# }
#
# g = function(...){
#   data.frame(...)
# }
#
# op = par(mar = c(1, 1, 1, 1))
# on.exit(par(op))
# x = seq(min(xvar), max(xvar), length.out = 50)
# y = seq(min(yvar), max(yvar), length.out = 50)
# z = outer(x, y, function(i, j) {
#   df = data.frame(i, j)
#   # names(df) = all.vars(formula(model))[2:3]
#   # predict(model, df)
# })
# names = all.vars(formula(model))
# p = persp(x, y, z, xlab = names[2], ylab = names[3], zlab = names[1],
#           phi = phi, theta = theta, ...)
# if (points) {
#   zvar.fit = fitted(model)
#   i.pos = 1 + (zvar.fit > zvar)
#   obs = trans3d(xvar, yvar, zvar, p)
#   pred = trans3d(xvar, yvar, zvar.fit, p)
#   points(obs, col = c("red", "blue")[i.pos], pch = 16)
#   segments(obs$x, obs$y, pred$x, pred$y)
# }
