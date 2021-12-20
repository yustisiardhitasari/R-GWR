# Satellite Derived Bathymetry using Adaptive GWR
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("/home/bidlit01/SDB/run_morotai/scripts")
f.path <- "morotaiRGB_L8_170809_aoi1"
f.trn <- "trn25"

# Import packages
library(raster)
library(rgdal)
library(shapefiles)
library(GWmodel)
library(data.table)
library(rgrass7)

# Read file
img.x	<- stack(readGDAL(paste("../img_crct/", f.path, "_crctm.tif", sep="")))
names(img.x) <- c("red", "green", "blue")
df.imgx <- read.table(paste("../df_extract/", f.path, "_dfimgx.csv", sep=""), header=TRUE, sep=",")
df.ext.trn <- read.table(paste("../df_extract/", f.path, "_df", f.trn, ".csv", sep=""), header=TRUE, sep=",")

# Convert to SpatialPointsDataFrame
sp.ext.trn <- SpatialPointsDataFrame(data=data.frame(df.ext.trn), coords=cbind(df.ext.trn$X, df.ext.trn$Y))
sp.imgx <- SpatialPointsDataFrame(data=data.frame(df.imgx), coords=cbind(df.imgx$X, df.imgx$Y))

# Calculate distance
dp.dist <- gw.dist(dp.locat=coordinates(sp.ext.trn))
rp.dist <- gw.dist(dp.locat=coordinates(sp.ext.trn), rp.locat=coordinates(sp.imgx))

# Calculate kernel bandwidth (adaptive)
bw.AGWR <- bw.gwr(formula=Z~red+green+blue, data=sp.ext.trn, approach="AICc", kernel="gaussian", adaptive=TRUE, dMat=dp.dist)

# Run gwr model (adaptive)
predict.AGWR <- gwr.predict(formula=Z~red+green+blue, data=sp.ext.trn, predictdata = sp.imgx, bw=bw.AGWR, kernel = "gaussian", adaptive = TRUE, dMat1=rp.dist, dMat2=dp.dist)
df.depthAGWR <- data.frame(predict.AGWR$SDF)
write.table(df.depthAGWR, paste("../results/", f.path, "_depthAGWR_", f.trn, ".csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
df.depthAGWR <- df.depthAGWR[,c(7,8,5)]
colnames(df.depthAGWR) <- c("X", "Y", "Z")
coordinates(df.depthAGWR) <- ~ X + Y
gridded(df.depthAGWR) <- TRUE
img.depthAGWR <- raster(df.depthAGWR)
writeRaster(img.depthAGWR, paste("../results/", f.path, "_depthAGWR_", f.trn, ".tif", sep=""))

# Calculate kernel bandwidth (fix)
bw.GWR <- bw.gwr(formula=Z~red+green+blue, data=sp.ext.trn, approach="AICc", kernel="bisquare", adaptive=FALSE, dMat=dp.dist)

# Run gwr model (fix)
predict.GWR <- gwr.predict(formula=Z~red+green+blue, data=sp.ext.trn, predictdata = sp.imgx, bw=bw.GWR, kernel = "bisquare", adaptive = FALSE, dMat1=rp.dist, dMat2=dp.dist)
df.depthGWR <- data.frame(predict.GWR$SDF)
write.table(df.depthGWR, paste("../results/", f.path, "_depthGWR_", f.trn, ".csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
df.depthGWR <- df.depthGWR[,c(7,8,5)]
colnames(df.depthGWR) <- c("X", "Y", "Z")
coordinates(df.depthGWR) <- ~ X + Y
gridded(df.depthGWR) <- TRUE
img.depthGWR <- raster(df.depthGWR)
writeRaster(img.depthGWR, paste("../results/", f.path, "_depthGWR_", f.trn, ".tif", sep=""))

