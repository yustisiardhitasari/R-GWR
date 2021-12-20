# R-GWR
 Geographically Weighted Regression in R

This repo is an implementation of Geographically Weighted Regression in R to extract shallow water depths from multispectral images.

## Data
This study used a restricted dataset so you need to prepare your own data. Some useful information:
- The Sentinel-2 images are open and accessible through the [Copernicus Open Access Hub](https://scihub.copernicus.eu/).
- The National Oceanic and Atmospheric Administration (NOAA) Bathymetric Data Viewer provides [MBES](https://maps.ngdc.noaa.gov/viewers/bathymetry/) and [LiDAR](https://coast.noaa.gov/dataviewer/\#/lidar/search/) bathymetry data sets.

## Directory tree structure
    .
    ├── depthref               # input depth reference data from single or multi beam echo sounding
    ├── df_extract             # dataframe extracted from the image and depth reference dataset
    ├── eval                   # evaluation results
    ├── img                    # input multispectral images
    ├── img_crct               # corrected images using averaged deep water pixels
    ├── results                # bathymetry model
    ├── scripts                # R scripts
    ├── shp                    # shapefiles to represent area of interest (aoi) or deep water area (dwa)    
    ├── LICENSE
    └── README.md

## R package requirements
- [raster](https://cran.r-project.org/web/packages/raster/raster.pdf)
- [shapefiles](https://cran.r-project.org/web/packages/shapefiles/shapefiles.pdf)
- [rgdal](https://cran.r-project.org/web/packages/rgdal/rgdal.pdf)
- [GWmodel](https://cran.r-project.org/web/packages/GWmodel/GWmodel.pdf)
- [data.table](https://cran.r-project.org/web/packages/data.table/data.table.pdf)

## Shallow water bathymetry modelling
### Stack multiple bands:
```
scripts/1_run_combine.R
```

### Image correction using deep water pixels:
```
scripts/2_run_crct_mean.R
```

### Convert image into dataframe format:
```
scripts/3_run_extract_imgtodf.R
```

### Convert depth reference shp into dataframe format and split into training and testing set:
```
scripts/3_run_extract_trndata.R
```

### Run the GWR (adaptive and fix):
```
scripts/4_run_gwr.R
```

### Run the evaluation:
```
scripts/5_run_accuracy.R
```

## Results
Results can be found in the [project report](https://doi.org/10.5194/isprs-archives-XLIII-B3-2020-453-2020).