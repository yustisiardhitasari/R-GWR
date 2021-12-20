# Calculate RMSE, R, R2, TVU, CL
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("D:/SDB/run_morotai/tvu/")
f.path <- "morotaiRGB_S2_170809_aoi2b"
f.sdb <- "AGWR"
f.ref <- "morotai_sbes_aoi2b"
f.trn <- "trn75"
f.tst <- "tst25"

# Import packages
library(raster)
library(rgdal)
library(shapefiles)

# Read file
img.depth <- stack(readGDAL(paste("../results/", f.path, "_depth", f.sdb, "_", f.trn, ".tif", sep="")))

# TVU, CL, RMSE, R, R2 (Depth All)
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, ".csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-3,-30), ylim = c(-3,-30))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, sep=""))

# Depth 0-5 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -5)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_0_5.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
par(mfrow=c(3,2))
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-3,-5), ylim = c(-2,-10))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 0-5 m", sep=""))

# Depth 5-10 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -10)
df.ref <- subset(df.ref, subset=df.ref$Z < -5)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_5_10.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-5,-10), ylim = c(-3,-18))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 5-10 m", sep=""))

# Depth 10-15 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -15)
df.ref <- subset(df.ref, subset=df.ref$Z < -10)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_10_15.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-10,-15), ylim = c(-6,-20))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 10-15 m", sep=""))

# Depth 15-20 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -20)
df.ref <- subset(df.ref, subset=df.ref$Z < -15)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_15_20.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-15,-20), ylim = c(-12,-22))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 15-20 m", sep=""))

# Depth 20-25 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -25)
df.ref <- subset(df.ref, subset=df.ref$Z < -20)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_20_25.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-20,-25), ylim = c(-15,-28))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 20-25 m", sep=""))

# Depth 25-30 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -30)
df.ref <- subset(df.ref, subset=df.ref$Z < -25)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_25_30.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-25,-30), ylim = c(-22,-30))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 25-30 m", sep=""))

# Depth 30-35 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -35)
df.ref <- subset(df.ref, subset=df.ref$Z < -30)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_30_35.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-30,-35), ylim = c(-15,-35))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 30-35 m", sep=""))

# Depth 35-40 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z >= -40)
df.ref <- subset(df.ref, subset=df.ref$Z < -35)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_35_40.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(-35,-36), ylim = c(-33,-35))
abline(lm(df.cl$ref~df.cl$pred))
title(main = paste("Depth SBES vs SDB ", f.sdb, " : 35-40 m", sep=""))

# Depth >40 m
df.ref <- read.table(paste("../depthref/", f.ref, "_df", f.tst, ".csv", sep=""), header=TRUE, sep=",")
df.ref <- subset(df.ref, subset=df.ref$Z < -40)
df.pred <- as.data.frame(extract(x = img.depth, y = df.ref[,1:2], methods = 'bilinear'))
df.cl <- abs(df.ref$Z - df.pred)
df.cl <- data.frame(X=df.ref$X, Y=df.ref$Y, ref=df.ref$Z, pred = df.pred, resd=df.cl)
df.cl <- na.omit(df.cl)
colnames(df.cl) <- c("X", "Y", "ref", "pred", "resd")
summary(df.cl)
rmse <- sqrt(mean(abs(df.cl$ref - df.cl$pred)^2))
rmse
a <- sum((abs(df.cl$ref-mean(df.cl$ref))) * (abs(df.cl$pred-mean(df.cl$pred))))
b <- sqrt(sum((abs(df.cl$ref-mean(df.cl$ref)))^2) * sum((abs(df.cl$pred-mean(df.cl$pred)))^2))
R <- a/b
R
R2 <- (R)^2
R2
a <- 0.5
b <- 0.013
for(i in 1:length(df.cl$resd)){
  TVU=sqrt(a^2+(b*df.cl$ref[i])^2)
  if(df.cl$resd[i]>TVU){
    count=0
  }else{
    count=1
  }
  df.cl[i, "tvu"] <- TVU
  df.cl[i, "unc"] <- count
}
CL <- sum(df.cl$unc)/length(df.cl$unc)
CL
write.table(df.cl, paste(f.path, "_resd", f.sdb, "_", f.trn, "_40.csv", sep=""), col.names=TRUE, row.names=FALSE, sep=",")
#plot(df.cl$ref,df.cl$pred, xlab="Depth SBES", ylab=paste("Depth ", f.sdb, sep=""), xlim = c(10,30), ylim = c(5,30))
#abline(lm(df.cl$ref~df.cl$pred))
#title(main = paste("Depth SBES vs SDB ", f.sdb, " : >40 m", sep=""))
