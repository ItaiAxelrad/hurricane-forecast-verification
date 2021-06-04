# chooseCRANmirror(ind <- 130)
#loading library. Install packages if not already installed
# install.packages("raster", lib <- "~/data/downloaded_packages")
# install.packages("ncdf4", lib <- "~/data/downloaded_packages")
# install.packages("gdalUtils", lib <- "~/data/downloaded_packages")
# install.packages("rgdal", lib <- "~/data/downloaded_packages")
# install.packages("REdaS", lib <- "~/data/downloaded_packages")
# install.packages("rgeos", lib <- "~/data/downloaded_packages")
library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

setwd("~/data/Isidore")

shp_read <- readOGR("~/data/Isidore", "Louisiana")
crs(shp_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "
L_shp <- spTransform(shp_read, CRS(new_crs))

#Hurricane Lili
day <- 13 #chosen max day
day_num <- c(301, 321) # days of year for ensemble
day_vec <- seq(as.Date("2002-09-07"),
as.Date("2002-10-04"),
by <- "Days")
#Lead_Time <- ‘LeadTime-0’
#Hurricane_Name <- ‘Hurricane-Isidore’
#Date <- ‘20020907-20021004’
#Paste <- (‘CanCM4_EnsNo-1’, Lead_Time, Hurricane_Name, Date, sep=” _”)

# ensemble 1
ens1 <- brick("CanCM4_EnsNo-1_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 2
ens2 <- brick("CanCM4_EnsNo-2_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 3
ens3 <- brick("CanCM4_EnsNo-3_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 4
ens4 <- brick("CanCM4_EnsNo-4_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 5
ens5 <- brick("CanCM4_EnsNo-5_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 6
ens6 <- brick("CanCM4_EnsNo-6_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 7
ens7 <- brick("CanCM4_EnsNo-7_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 8
ens8 <- brick("CanCM4_EnsNo-8_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 9
ens9 <- brick("CanCM4_EnsNo-9_LeadTime-0_Hurricane-Isidore_20020907-20021004")
# ensemble 10
ens10 <- brick("CanCM4_EnsNo-10_LeadTime-0_Hurricane-Isidore_20020907-20021004")

#ens_avg <- (ens1_mask+ens2_mask+ens3_mask+ens4_mask+ens5_mask+ens6_mask+ens7_mask+
#             ens8_mask+ens9_mask+ens10_mask)/10


#setwd("Z:~/data/Isidore")

obs_data <- brick("prcp_trmm_2007.nc")
obs_mask <- mask(obs_data[[day_num[1] + day]], L_shp)
obs_mat <- as.matrix(obs_mask)
obs_brick <- brick(obs_data[[day_num[1]:day_num[2]]])

err_rast <- abs(obs_mask - ens_avg)
err_mat <- as.matrix(err_rast)
max_err <- max(obs_mat, na.rm <- TRUE)
max_err_loc <- which(obs_mat == max_err, arr.ind <- TRUE)


pixel_lat <- max_err_loc[1]
pixel_long <- max_err_loc[2]
Latitude <- 33.01946 - (pixel_lat * 0.25)
Longitude <- -94.04316 + (pixel_long * 0.25)


#ens_brick <- brick(ens1_mask,ens2_mask,ens3_mask,ens4_mask,ens5_mask,ens6_mask,
#                  ens7_mask,ens8_mask,ens9_mask,ens10_mask)

days <- dim(ens1)[3]
ens_vals <- rep(0, days)
obs_vals <- rep(0, days)

for (i in 1:days) {
  # ensemble 1
  ens1_mask <- mask(ens1[[i]], L_shp)
  # ensemble 2
  ens2_mask <- mask(ens2[[i]], L_shp)
  # ensemble 3
  ens3_mask <- mask(ens3[[i]], L_shp)
  # ensemble 4
  ens4_mask <- mask(ens4[[i]], L_shp)
  # ensemble 5
  ens5_mask <- mask(ens5[[i]], L_shp)
  # ensemble 6
  ens6_mask <- mask(ens6[[i]], L_shp)
  # ensemble 7
  ens7_mask <- mask(ens7[[i]], L_shp)
  # ensemble 8
  ens8_mask <- mask(ens8[[i]], L_shp)
  # ensemble 9
  ens9_mask <- mask(ens9[[i]], L_shp)
  # ensemble 10
  ens10_mask <- mask(ens10[[i]], L_shp)
  ens_avg <- (ens1_mask + ens2_mask + ens3_mask + ens4_mask + ens5_mask + ens6_mask + ens7_mask +
               ens8_mask + ens9_mask + ens10_mask) / 10
  ens_mat <- as.matrix(ens_avg)
  obs_mask <- mask(obs_brick[[i]], L_shp)
  obs_mat <- as.matrix(obs_mask)
  ens_vals[i] <- ens_mat[pixel_lat, pixel_long]
  obs_vals[i] <- obs_mat[pixel_lat, pixel_long]
}

max_y <- ceiling(max(c(obs_vals, ens_vals)))
plot(obs_vals, ylim <- c(0, max_y), type <- "l")
lines(ens_vals, type <- "l", col <- "red")
