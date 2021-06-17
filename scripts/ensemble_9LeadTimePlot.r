setwd("~/data/Cindy")

library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

# TRMM Map
# Hurricane Cindy TRMM Data
file_list_precip_TRMM <- list.files(pattern <- glob2rx("prcp_trmm_2005.nc"))
Cindy_TRMM <- brick(file_list_precip_TRMM)
Cindy_TRMM
plot(Cindy_TRMM[[187]]) # for July 6, 2005 (peak date in LA)

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
Louisiana_shp <- list.files(pattern <- glob2rx("Louisiana.shp"))
Louisiana_shp
shape_read <- readOGR("Louisiana.shp")
crs(shape_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift <- spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add <- TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_TRMM <- crop(Cindy_TRMM[[187]], shape_shift)
mask_TRMM <- mask(netcdf_cropped_TRMM, shape_shift)
plot(mask_TRMM)
plot(shape_shift, add <- TRUE)

# finding maximum value of precipitation accross all space in cropped area
max_TRMM <- extract(mask_TRMM, shape_shift, max, na.rm <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 0
file_list_precip_Ens1LT0 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-0_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT0 <- brick(file_list_precip_Ens1LT0)
Cindy_Ens1LT0
plot(Cindy_Ens1LT0[[11]]) # For July 6, 2005

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT0 <- crop(Cindy_Ens1LT0[[11]], shape_shift)
mask_Ens1LT0 <- mask(netcdf_cropped_Ens1LT0, shape_shift)
plot(mask_Ens1LT0)
plot(shape_shift, add <- TRUE)

# finding maximum value of precipitation accross all space in cropped area
max_LT0 <- extract(mask_Ens1LT0, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 0 compared to TRMM
Error_Ens1LT0 <- mask_TRMM - mask_Ens1LT0

# Hurricane Cindy- Ensemble #1, Lead Time 1
file_list_precip_Ens1LT1 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-1_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT1 <- brick(file_list_precip_Ens1LT1)
Cindy_Ens1LT1
plot(Cindy_Ens1LT1[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)

# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT1 <- crop(Cindy_Ens1LT1[[11]], shape_shift)
mask_Ens1LT1 <- mask(netcdf_cropped_Ens1LT1, shape_shift)
plot(mask_Ens1LT1)
plot(shape_shift, add <- TRUE)

# finding maximum value of precipitation accross all space in cropped area
max_LT1 <- extract(mask_Ens1LT1, shape_shift, max, na.rm <- TRUE)

# Spatial error of Ensemble 1, Lead Time 1 compared to TRMM
Error_Ens1LT1 <- (mask_TRMM - mask_Ens1LT1)
plot(Error_Ens1LT1)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 2
file_list_precip_Ens1LT2 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-2_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT2 <- brick(file_list_precip_Ens1LT2)
Cindy_Ens1LT2
plot(Cindy_Ens1LT2[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT2 <- crop(Cindy_Ens1LT2[[11]], shape_shift)
mask_Ens1LT2 <- mask(netcdf_cropped_Ens1LT2, shape_shift)
plot(mask_Ens1LT2)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT2 <- extract(mask_Ens1LT2, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 1 compared to TRMM
Error_Ens1LT2 <- (mask_TRMM - mask_Ens1LT2)
plot(Error_Ens1LT2)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 3
file_list_precip_Ens1LT3 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-3_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT3 <- brick(file_list_precip_Ens1LT3)
Cindy_Ens1LT3
plot(Cindy_Ens1LT3[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT3 <- crop(Cindy_Ens1LT3[[11]], shape_shift)
mask_Ens1LT3 <- mask(netcdf_cropped_Ens1LT3, shape_shift)
plot(mask_Ens1LT3)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT3 <- extract(mask_Ens1LT3, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 3 compared to TRMM
Error_Ens1LT3 <- (mask_TRMM - mask_Ens1LT3)
plot(Error_Ens1LT3)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 4
file_list_precip_Ens1LT4 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-4_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT4 <- brick(file_list_precip_Ens1LT4)
Cindy_Ens1LT4
plot(Cindy_Ens1LT4[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT4 <- crop(Cindy_Ens1LT4[[11]], shape_shift)
mask_Ens1LT4 <- mask(netcdf_cropped_Ens1LT4, shape_shift)
plot(mask_Ens1LT4)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT4 <- extract(mask_Ens1LT4, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 4 compared to TRMM
Error_Ens1LT4 <- (mask_TRMM - mask_Ens1LT4)
plot(Error_Ens1LT4)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 5
file_list_precip_Ens1LT5 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-5_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT5 <- brick(file_list_precip_Ens1LT5)
Cindy_Ens1LT5
plot(Cindy_Ens1LT5[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT5 <- crop(Cindy_Ens1LT5[[11]], shape_shift)
mask_Ens1LT5 <- mask(netcdf_cropped_Ens1LT5, shape_shift)
plot(mask_Ens1LT5)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT5 <- extract(mask_Ens1LT5, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 5 compared to TRMM
Error_Ens1LT5 <- (mask_TRMM - mask_Ens1LT5)
plot(Error_Ens1LT5)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 6
file_list_precip_Ens1LT6 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-6_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT6 <- brick(file_list_precip_Ens1LT6)
Cindy_Ens1LT6
plot(Cindy_Ens1LT6[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT6 <- crop(Cindy_Ens1LT6[[11]], shape_shift)
mask_Ens1LT6 <- mask(netcdf_cropped_Ens1LT6, shape_shift)
plot(mask_Ens1LT6)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT6 <- extract(mask_Ens1LT6, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 6 compared to TRMM
Error_Ens1LT6 <- (mask_TRMM - mask_Ens1LT6)
plot(Error_Ens1LT6)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 7
file_list_precip_Ens1LT7 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-7_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT7 <- brick(file_list_precip_Ens1LT7)
Cindy_Ens1LT7
plot(Cindy_Ens1LT7[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT7 <- crop(Cindy_Ens1LT7[[11]], shape_shift)
mask_Ens1LT7 <- mask(netcdf_cropped_Ens1LT7, shape_shift)
plot(mask_Ens1LT7)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT7 <- extract(mask_Ens1LT7, shape_shift, max, na.rm <- TRUE)
# Spatial error of Ensemble 1, Lead Time 7 compared to TRMM
Error_Ens1LT7 <- (mask_TRMM - mask_Ens1LT7)
plot(Error_Ens1LT7)
plot(shape_shift, add <- TRUE)

# Hurricane Cindy- Ensemble #1, Lead Time 8
file_list_precip_Ens1LT8 <- list.files(pattern <- glob2rx("CanCM4_EnsNo-1_LeadTime-8_Hurricane-Cindy_20050626-20050719.nc"))
Cindy_Ens1LT8 <- brick(file_list_precip_Ens1LT8)
Cindy_Ens1LT8
plot(Cindy_Ens1LT8[[11]]) # For July 6, 2005
# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Cindy
plot(shape_shift, add <- TRUE)
# adding shapefile to plot and cropping
netcdf_cropped_Ens1LT8 <- crop(Cindy_Ens1LT8[[11]], shape_shift)
mask_Ens1LT8 <- mask(netcdf_cropped_Ens1LT8, shape_shift)
plot(mask_Ens1LT8)
plot(shape_shift, add <- TRUE)
# finding maximum value of precipitation accross all space in cropped area
max_LT8 <- extract(mask_Ens1LT8, shape_shift, max, na.rm <- TRUE)

par(mfrow <- c(3, 3))

# Spatial error of Ensemble 1, Lead Time 0 compared to TRMM
Error_Ens1LT0 <- (mask_TRMM - mask_Ens1LT0)
plot(Error_Ens1LT0, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 0 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 1 compared to TRMM
Error_Ens1LT1 <- (mask_TRMM - mask_Ens1LT1)
plot(Error_Ens1LT1, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 1 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 2 compared to TRMM
Error_Ens1LT2 <- (mask_TRMM - mask_Ens1LT2)
plot(Error_Ens1LT2, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 2 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 3 compared to TRMM
Error_Ens1LT3 <- (mask_TRMM - mask_Ens1LT3)
plot(Error_Ens1LT3, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 3 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 4 compared to TRMM
Error_Ens1LT4 <- (mask_TRMM - mask_Ens1LT4)
plot(Error_Ens1LT4, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 4 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 5 compared to TRMM
Error_Ens1LT5 <- (mask_TRMM - mask_Ens1LT5)
plot(Error_Ens1LT5, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 5 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 6 compared to TRMM
Error_Ens1LT6 <- (mask_TRMM - mask_Ens1LT6)
plot(Error_Ens1LT6, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 6 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 7 compared to TRMM
Error_Ens1LT7 <- (mask_TRMM - mask_Ens1LT7)
plot(Error_Ens1LT7, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 7 Error")
plot(shape_shift, add <- TRUE)

# Spatial error of Ensemble 1, Lead Time 8 compared to TRMM
Error_Ens1LT8 <- (mask_TRMM - mask_Ens1LT8)
plot(Error_Ens1LT8, xlab <- "Longitude", ylab <- "Latitude", main <- "Ens 1 Lead Time 8 Error")
plot(shape_shift, add <- TRUE)
