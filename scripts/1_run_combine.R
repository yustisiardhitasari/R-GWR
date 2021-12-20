# Combine Multiple Bands
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

setwd("/home/rgwr/img/")

library(raster)
library(shapefiles)
library(rgdal)

#-------------------------------------------------------------------------------------------
# LANDSAT8
b2 <- raster("LC08_L1TP_109059_20170809_20170823_01_T1_B2.TIF")	#blue
b3 <- raster("LC08_L1TP_109059_20170809_20170823_01_T1_B3.TIF")	#green
b4 <- raster("LC08_L1TP_109059_20170809_20170823_01_T1_B4.TIF")	#red
b5 <- raster("LC08_L1TP_109059_20170809_20170823_01_T1_B5.TIF")	#nir

imgRGB <- stack(b4, b3, b2)
newproj <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
imgRGB <- projectRaster(imgRGB, crs=newproj)
names(imgRGB) <- c("red", "green", "blue")
writeRaster(imgRGB, "imgRGB_L8_170809.tif")

# SENTINEL-2
b2 <- raster("T52NDH_20170809T015621_B02.jp2")	#blue
b3 <- raster("T52NDH_20170809T015621_B03.jp2")	#green
b4 <- raster("T52NDH_20170809T015621_B04.jp2")	#red
b8 <- raster("T52NDH_20170809T015621_B08.jp2")	#nir

imgRGB <- stack(b4, b3, b2)
newproj <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
imgRGB <- projectRaster(imgRGB, crs=newproj)
names(imgRGB) <- c("red", "green", "blue")
writeRaster(imgRGB, "imgRGB_S2_170809.tif")
