setwd("~/data/Dennis")

chooseCRANmirror(ind = 130)
install.packages("raster", lib = "~/downloaded_packages")
install.packages("ncdf4", lib = "~/downloaded_packages")
install.packages("gdalUtils", lib = "~/downloaded_packages")
install.packages("rgdal", lib = "~/downloaded_packages")
install.packages("REdaS", lib = "~/downloaded_packages")
install.packages("rgeos", lib = "~/downloaded_packages")

library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

file_list_precip = list.files(pattern = glob2rx('CanCM4_EnsNo-1_LeadTime-0_Hurricane-Dennis_20050627-20050725.nc'))
Dennis_Ens1 = brick(file_list_precip)
dim(Dennis_Ens1)
Dennis_Ens1
class(Dennis_Ens1)
plot(Dennis_Ens1[[14]]) #For July 9, 2005

# Using Louisiana ShapeFile to plot Louisiana over latitude/longitude data for Dennis
Louisiana_shp = list.files(pattern = glob2rx('Louisiana.shp'))
Louisiana_shp
shape_read = readOGR('Louisiana.shp')
crs(shape_read)
new_crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
shape_shift = spTransform(shape_read, CRS(new_crs))
plot(shape_shift, add = TRUE)

#adding shapefile to plot and cropping
netcdf_cropped = crop(Dennis_Ens1[[14]], shape_shift)
mask = mask(netcdf_cropped, shape_shift)
plot(mask)
plot(shape_shift, add = TRUE)

# finding maximum value of precipitation across all space in cropped area
netcdf_extract = extract(netcdf_cropped, shape_shift, max, na.rm = TRUE)
length(netcdf_extract)
netcdf_extract
summary(netcdf_cropped)

