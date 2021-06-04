setwd("~/data/TRMM")
library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

# Hurricane Cindy TRMM Data
file_list_precip <- list.files(pattern <- glob2rx("prcp_trmm_2005.nc"))
Cindy_TRMM1 <- brick(file_list_precip)
dim(Cindy_Ens1)
Cindy_TRMM1
class(Cindy_TRMM1)
plot(Cindy_TRMM1[[187]]) # for July 6, 2005 (peak date in LA)

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
Louisiana_shpT <- list.files(pattern <- glob2rx("Louisiana.shp"))
Louisiana_shpT
shape_readT <- readOGR("Louisiana.shp")
crs(shape_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shiftT <- spTransform(shape_readT, CRS(new_crs))
plot(shape_shift, add <- TRUE)

all_timestepsT <- stackApply(Cindy_TRMM1, indices <- 1, fun <- mean)
plot(all_timestepsT)

netcdf_croppedT <- crop(all_timestepsT, shape_shiftT)
plot(netcdf_croppedT)
plot(shape_shiftT, add <- TRUE)
netcdf_extracTt <- extract(all_timesteps, shape_shift, mean, na.rm <- TRUE)
length(netcdf_extractT)
netcdf_extractT
summary(netcdf_croppedT)
cellStats(netcdf_croppedT, stat <- "mean", na.rm <- TRUE)

#Checking Error between TRMM and Ens1
test <- netcdf_croppedT - netcdf_cropped
plot(test)
plot(shape_shift, add <- TRUE)