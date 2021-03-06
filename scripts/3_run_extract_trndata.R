# Extract img into data frame
# Yustisi Lumban-Gaol
# Bidang Penelitian - Badan Informasi Geospasial

# Setting
setwd("/home/rgwr/df_extract")
f.aoi <- "aoi"
f.trn <- "trn75"
f.tst <- "tst25"

# Import packages
library(raster)
library(rgdal)
library(shapefiles)

# Read file
shp.depth <- shapefile(paste("../depthref/sbes_", f.aoi, ".shp", sep=""))

# Extract depth reference
df.depth	<- data.frame(x = shp.depth)
df.depth	<- df.depth[,1:3]
colnames(df.depth) <- c("X", "Y", "Z")
write.table(df.depth, paste("../depthref/sbes_", f.aoi, "_df.csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
df.depth <- read.table(paste("../depthref/sbes_", f.aoi, ".csv", sep=""), header=TRUE, sep=",")

# Split training dan testing data
smp_size <- floor(0.75 * nrow(df.depth))
trn <- sample(seq_len(nrow(df.depth)), size=smp_size)
df.ext.trn <- df.depth[trn, ]
df.ext.tst <- df.depth[-trn, ]
write.table(df.ext.trn, paste("../depthref/sbes_", f.aoi, "_df", f.trn, ".csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
write.table(df.ext.tst, paste("../depthref/sbes_", f.aoi, "_df", f.tst, ".csv", sep=""), col.names = TRUE, row.names = FALSE, sep = ",")
