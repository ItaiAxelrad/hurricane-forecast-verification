#Hurricane Cindy
library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(grid)
library(REdaS)
library(rgeos)

setwd("~/Documents/GitHub/hurricane-forecast-verification/data/ensembles/Cindy/")
#24 days of precipitation data from 06/26/2005- 07/19/2005
file_list_precip <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-0_Hurricane-Cindy_20050626-20050719.nc"))
file_list_precip
Cindy_Ens1 <- brick(file_list_precip)
dim(Cindy_Ens1)
Cindy_Ens1
class(Cindy_Ens1)
plot(Cindy_Ens1[[11]]) # For July 6, 2005

setwd("~/Documents/GitHub/hurricane-forecast-verification/data/shapefiles")
# Using Louisiana Shape file to plot Louisiana over latitude/longitude data for Cindy
dsn <- "Louisiana.shp"
Louisiana_shp <- list.files(pattern <- glob2rx(dsn))
Louisiana_shp
shape_read <- readOGR(dsn)
crs(shape_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift <- spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add <- TRUE)

all_timesteps <- stackApply(Cindy_Ens1, indices <- 1, fun <- mean)
plot(all_timesteps)

netcdf_cropped <- crop(all_timesteps, shape_shift)
plot(netcdf_cropped)
plot(shape_shift, add <- TRUE)

netcdf_extract <- extract(all_timesteps, shape_shift, mean, na.rm <- TRUE)
length(netcdf_extract)
netcdf_extract

summary(netcdf_cropped)
cellStats(netcdf_cropped, stat <- "mean", na.rm <- TRUE)
