# chooseCRANmirror(ind <- 130)
library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

setwd("Z:/Desktop/CEE 250A/Lili")

# input peak date
TRMM_peak <- 276
ens_peak <- 19

# TRMM Data Import
file_list_precip_TRMM <- list.files(pattern <- glob2rx("prcp_trmm_2002.nc"))
TRMM <- brick(file_list_precip_TRMM)
plot(TRMM[[TRMM_peak]])

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Lili
Louisiana_shp <- list.files(pattern <- glob2rx("Louisiana.shp"))
Louisiana_shp
shape_read <- readOGR("Louisiana.shp")
crs(shape_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift <- spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add <- TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_TRMM <- crop(TRMM[[TRMM_peak]], shape_shift)
mask_TRMM <- mask(netcdf_cropped_TRMM, shape_shift)
plot(mask_TRMM)
plot(shape_shift, add <- TRUE)

# Load Ensemble with corresponding lead time
file_list_precip_ens <- list.files(pattern <- glob2rx("CanCM4_ensNo-1_LeadTime-0_Hurricane-Lili_20020914-20021011.nc"))
Ens <- brick(file_list_precip_ens)
Ens
plot(Ens[[ens_peak]]) # For October 3, 2002
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_ens <- crop(Ens[[ens_peak]], shape_shift)
mask_ens <- mask(netcdf_cropped_ens, shape_shift)
plot(mask_ens)
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble compared to trip (map)
Error_ens <- (mask_TRMM - mask_ens)

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

raster_to_matrix_trmm <- as.matrix(mask_TRMM)
trmm_at_max_error <- raster_to_matrix_trmm[pixel_lat, pixel_long]
raster_to_matrix_ens <- as.matrix(mask_ens)
ens_at_max_error <- raster_to_matrix_ens[pixel_lat, pixel_long]
