# Satellite image correction using averaged deep water radiance
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("/home/rgwr/img_crct")
f.path <- "imgRGB_S2_170809"
f.aoi <- "aoi"
f.dwa <- "dwa"

# Import packages
library(raster)
library(shapefiles)
library(rgdal)

# Read data
newproj <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
img.rgb <- stack(readGDAL(paste("../img/", f.path, "_", f.aoi, ".tif", sep="")))
#img.rgb <- projectRaster(img.rgb, crs=newproj)
img.rgb.full <- stack(readGDAL(paste("../img/", f.path, ".img", sep="")))
img.rgb.full <- projectRaster(img.rgb.full, crs=newproj)
img.r <- img.rgb.full[[1]]
img.g <- img.rgb.full[[2]]
img.b <- img.rgb.full[[3]]

# Crop aoi
shp.aoi <- shapefile(paste("../shp/", f.aoi, ".shp", sep=""))
img.rgb <- crop(img.rgb.full, extent(shp.aoi))
writeRaster(img.rgb, paste("../img/", f.path, "_", f.aoi, ".tif", sep=""))

# Set deep water area (dwa)
shp.dwa <- shapefile(paste("../shp/", f.dwa, ".shp", sep=""))

# Extract data raster dwa
img.dwa	<- crop(img.rgb.full, extent(shp.dwa))

# Satellite image correction using averaged deep water radiance
mean.LD <- cellStats(x=img.dwa, stat='mean')
img.x.mean <- log(img.rgb - mean.LD)
names(img.x.mean) <- c("red", "green", "blue")
writeRaster(img.x.mean, paste(f.path, "_", f.aoi, "_", f.dwa, "_crctm.tif", sep=""))
