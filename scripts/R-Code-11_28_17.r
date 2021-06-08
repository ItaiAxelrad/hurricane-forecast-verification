setwd("~/data/Cindy")

library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

# input peak date
trmm_peak <- 187
ens_peak <- 11

# trmm Data Import
file_list_precip_trmm <- list.files(pattern <- glob2rx("prcp_trmm_2005.nc"))
trmm <- brick(file_list_precip_trmm)
plot(trmm[[trmm_peak]])

# Using Louisiana ShapeFile to plot louisiana over latitude/longitude data for Cindy
louisiana_shp <- list.files(pattern <- glob2rx("louisiana.shp"))
louisiana_shp
shape_read <- readOGR("louisiana.shp")
crs(shape_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift <- spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add <- TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_trmm <- crop(trmm[[trmm_peak]], shape_shift)
mask_trmm <- mask(netcdf_cropped_trmm, shape_shift)
plot(mask_trmm)
plot(shape_shift, add <- TRUE)

# Load ensemble with corresponding lead time
file_list_precip_ens <- list.files(pattern <- glob2rx("CanCM4_ensNo-1_LeadTime-0_Hurricane-Cindy_20050626-20050719.nc"))
ens <- brick(file_list_precip_ens)
ens
plot(ens[[ens_peak]]) # For July 6, 2005
# Using louisiana ShapeFile to plot louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_ens <- crop(ens[[ens_peak]], shape_shift)
mask_ens <- mask(netcdf_cropped_ens, shape_shift)
plot(mask_ens)
plot(shape_shift, add <- TRUE)

# Spatial error of ensemble compared to trip (map)
Error_ens <- (mask_trmm - mask_ens)

# Change the values in the raster to a matrix
raster_to_matrix <- as.matrix(Error_ens)
# Find the maximum value of the error
max_error <- max(raster_to_matrix, na.rm <- TRUE)
max_error_location <- which(raster_to_matrix == max_error, arr.ind <- TRUE)

# plot error spatially
plot(Error_ens, xlab <- "Longitude", ylab <- "Latitude", main <- "Title")
plot(shape_shift, add <- TRUE)

pixel_long <- max_error_location[2]
pixel_lat <- max_error_location[1]
longitude <- -94.04316 + (pixel_long * 0.25)
latitude <- 33.01946 - (pixel_lat * 0.25)

raster_to_matrix_trmm <- as.matrix(mask_trmm)
trmm_at_max_error <- raster_to_matrix_trmm[pixel_lat, pixel_long]
raster_to_matrix_ens <- as.matrix(mask_ens)
ens_at_max_error <- raster_to_matrix_ens[pixel_lat, pixel_long]
