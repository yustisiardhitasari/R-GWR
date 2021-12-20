# Extract img into data frame
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("/home/rgwr/df_extract")
f.path <- "imgRGB_S2_170809"
f.aoi <- "aoi"
f.trn <- "trn75"

# Import packages
library(raster)
library(rgdal)
library(shapefiles)

# Read file
img.x	<- stack(readGDAL(paste("../img_crct/", f.path, "_", f.aoi, "_crctm.tif", sep="")))
df.depth <- read.table(paste("../depthref/sbes_", f.aoi, "_df", f.trn, ".csv", sep=""), header=TRUE, sep=",")

# Extract depth reference and pixel value
df.ext	<- as.data.frame(extract(x = img.x, y = df.depth[,1:2], methods = 'bilinear'))
df.ext 	<- cbind(df.depth$X, df.depth$Y, df.depth$Z, df.ext)
colnames(df.ext) <- c("X", "Y", "Z", "red", "green", "blue")
df.ext <- subset(x = df.ext, subset = df.ext$Z < 0)
#df.ext <- subset(x = df.ext, subset = df.ext$Z >= -30)
df.ext <- na.omit(df.ext)
write.table(df.ext, paste(f.path, "_", f.aoi, "_df", f.trn, ".csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")

# RasterStack to dataframe
df.imgx <- as.data.frame(x=img.x, xy=TRUE, na.rm=TRUE)
colnames(df.imgx) <- c("X", "Y", "red", "green", "blue")
write.table(df.imgx, paste(f.path, "_", f.aoi, "_dfimgx.csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
