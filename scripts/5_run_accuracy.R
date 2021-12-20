# Calculate RMSE, R, R2, TVU, CL
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("/home/rgwr/eval/")
f.path <- "imgRGB_S2_170809_aoi"
f.sdb <- "AGWR"
f.ref <- "sbes_aoi"
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
