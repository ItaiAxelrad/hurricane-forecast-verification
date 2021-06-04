setwd("~/data/Cindy")

library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

# input peak date
TRMM_peak = 187
Ens_peak = 11

# TRMM Data Import
file_list_precip_TRMM = list.files(pattern = glob2rx('prcp_trmm_2005.nc'))
TRMM = brick(file_list_precip_TRMM)
plot(TRMM[[TRMM_peak]])

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
Louisiana_shp = list.files(pattern = glob2rx('Louisiana.shp'))
Louisiana_shp
shape_read = readOGR('Louisiana.shp')
crs(shape_read)
new_crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift = spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add = TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_TRMM = crop(TRMM[[TRMM_peak]], shape_shift)
mask_TRMM = mask(netcdf_cropped_TRMM, shape_shift)
plot(mask_TRMM)
plot(shape_shift, add = TRUE)

# Load Ensemble with corresponding lead time
file_list_precip_Ens = list.files(pattern = glob2rx('CanCM4_EnsNo-1_LeadTime-0_Hurricane-Cindy_20050626-20050719.nc'))
Ens = brick(file_list_precip_Ens)
Ens
plot(Ens[[Ens_peak]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add = TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens = crop(Ens[[Ens_peak]], shape_shift)
mask_Ens = mask(netcdf_cropped_Ens, shape_shift)
plot(mask_Ens)
plot(shape_shift, add = TRUE)

# Spatial error of Ensemble compared to trip (map)
Error_Ens = (mask_TRMM - mask_Ens)

# Change the values in the raster to a matrix
raster_to_matrix = as.matrix(Error_Ens)
# Find the maximum value of the error
Max_error = max(raster_to_matrix, na.rm = TRUE)
Max_error_location = which(raster_to_matrix == Max_error, arr.ind = TRUE)

# plot error spatially
plot(Error_Ens, xlab = "Longitude", ylab = "Latitude", main = "Title")
plot(shape_shift, add = TRUE)

pixel_long = Max_error_location[2]
pixel_lat = Max_error_location[1]
Longitude = -94.04316 + (pixel_long * 0.25)
Latitude = 33.01946 - (pixel_lat * 0.25)

raster_to_matrix_TRMM = as.matrix(mask_TRMM)
TRMM_at_max_error = raster_to_matrix_TRMM[pixel_lat, pixel_long]
raster_to_matrix_Ens = as.matrix(mask_Ens)
Ens_at_max_error = raster_to_matrix_Ens[pixel_lat, pixel_long]


