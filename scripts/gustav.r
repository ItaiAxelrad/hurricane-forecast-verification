#Install packages if not already installed
#loading library
library(raster)
library(ncdf4)
library(rgdal)
library(gdalUtils)
library(REdaS)
library(rgeos)

setwd("~/Documents/GitHub/hurricane-forecast-verification/data/shapefiles")
#shp_read <- readOGR(dsn=path.expand("Louisiana.shp"))
shp_read <- shapefile("Louisiana")
crs(shp_read)
new_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
L_shp <- spTransform(shp_read, CRS(new_crs))
#chosen max day
day <- 14
# days of year for ensemble
day_num <- c(231, 258)

#Hurricane Gustav
setwd("~/Documents/GitHub/hurricane-forecast-verification/data/ensembles/Gustav")
## LEAD TIME 0 **************************************************************
# ensemble 1
ens1 <- brick("CanCM4_EnsNo-1_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 2
ens2 <- brick("CanCM4_EnsNo-2_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 3
ns3 <- brick("CanCM4_EnsNo-3_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 4
ens4 <- brick("CanCM4_EnsNo-4_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 5
ens5 <- brick("CanCM4_EnsNo-5_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 6
ens6 <- brick("CanCM4_EnsNo-6_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 7
ens7 <- brick("CanCM4_EnsNo-7_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 8
ens8 <- brick("CanCM4_EnsNo-8_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 9
ens9 <- brick("CanCM4_EnsNo-9_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 10
ens10 <- brick("CanCM4_EnsNo-10_LeadTime-0_Hurricane-Gustav_20080818-20080914.nc")

# Observed TRMM precipitation data
setwd("~/Documents/GitHub/hurricane-forecast-verification/data/TRMM")
# Gustov, year 2008
obs_data <- brick("prcp_trmm_2008.nc")
obs_mask <- mask(obs_data[[day_num[1] + day]], L_shp)
obs_mat <- as.matrix(obs_mask)
obs_brick <- brick(obs_data[[day_num[1]:day_num[2]]])
max_err <- max(obs_mat, na.rm <- TRUE)
max_err_loc <- which(obs_mat == max_err, arr.ind <- TRUE)
pixel_lat <- max_err_loc[1]
pixel_long <- max_err_loc[2]
latitude <- 33.01946 + -(pixel_lat * 0.25)
longitude <- -94.04316 + (pixel_long * 0.25)
days <- dim(ens1)[3]
ens_l0_vals <- rep(0, days)
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
  ens_l0_vals[i] <- ens_mat[pixel_lat, pixel_long]
  obs_vals[i] <- obs_mat[pixel_lat, pixel_long]
}
## LEAD TIME 4 *****************************************************************
setwd("~/Documents/GitHub/hurricane-forecast-verification/data/ensembles/Gustav")
# ensemble 1
ens1 <- brick("CanCM4_EnsNo-1_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 2
ens2 <- brick("CanCM4_EnsNo-2_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 3
ens3 <- brick("CanCM4_EnsNo-3_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 4
ens4 <- brick("CanCM4_EnsNo-4_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 5
ens5 <- brick("CanCM4_EnsNo-5_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 6
ens6 <- brick("CanCM4_EnsNo-6_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 7
ens7 <- brick("CanCM4_EnsNo-7_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 8
ens8 <- brick("CanCM4_EnsNo-8_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 9
ens9 <- brick("CanCM4_EnsNo-9_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 10
ens10 <- brick("CanCM4_EnsNo-10_LeadTime-4_Hurricane-Gustav_20080818-20080914.nc")

ens_l4_vals <- rep(0, days)
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
  ens_l4_vals[i] <- ens_mat[pixel_lat, pixel_long]
}
## LEAD TIME 8 *********************************************************************
# ensemble 1
ens1 <- brick("CanCM4_EnsNo-1_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 2
ens2 <- brick("CanCM4_EnsNo-2_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 3
ens3 <- brick("CanCM4_EnsNo-3_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 4
ens4 <- brick("CanCM4_EnsNo-4_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 5
ens5 <- brick("CanCM4_EnsNo-5_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 6
ens6 <- brick("CanCM4_EnsNo-6_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 7
ens7 <- brick("CanCM4_EnsNo-7_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 8
ens8 <- brick("CanCM4_EnsNo-8_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 9
ens9 <- brick("CanCM4_EnsNo-9_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")
# ensemble 10
ens10 <- brick("CanCM4_EnsNo-10_LeadTime-8_Hurricane-Gustav_20080818-20080914.nc")

ens_l8_vals <- rep(0, days)
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
  ens_l8_vals[i] <- ens_mat[pixel_lat, pixel_long]
}

## PLOT REGULAR
day_vec <- seq(as.Date("2008-08-18"), as.Date("2008-09-14"), by <- "days")
par(mfrow <- c(3, 1), mar <- c(0.6, 5.1, 0, 0.6), oma <- c(5.1, 0, 3, 1))

#plot leadtime 0
max_y <- ceiling(max(c(obs_vals, ens_l0_vals)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)", ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l0_vals, type <- "l", col <- "red")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1), lwd <- c(2, 2), col <- c("black", "red"), title <- "Lead Time 0")

#plot leadtime 4
max_y <- ceiling(max(c(obs_vals, ens_l4_vals)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)",
ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l4_vals, type <- "l", col <- "cyan")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1),
lwd <- c(2, 2), col <- c("black", "cyan"), title <- "Lead Time 4")

#plot leadtime 8
max_y <- ceiling(max(c(obs_vals, ens_l8_vals)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)",
ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l8_vals, type <- "l", col <- "green")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1),
lwd <- c(2, 2), col <- c("black", "green"), title <- "Lead Time 8")
ticks <- seq(from <- min(day_vec), by <- "2 days", length <- (day_num[2] - day_num[1] + 2) / 2) 
lbl <- strftime(ticks, "%b-%d")
axis(side <- 1, outer <- TRUE, at <- ticks, labels <- lbl)
mtext("2008", side <- 1, outer <- TRUE, line <- 3, cex <- 1)
mtext("Hurricane Gustav Lead Time Comparison", side <- 3,
outer <- TRUE, line <- 1, cex <- 1.5)

## PLOT SQUARED
day_vec <- seq(as.Date("2008-08-18"), as.Date("2008-09-14"), by <- "days")
par(mfrow <- c(3, 1), mar <- c(0.6, 5.1, 0, 0.6), oma <- c(5.1, 0, 3, 1))

#plot leadtime 0
max_y <- ceiling(max(c(obs_vals, ens_l0_vals ^ 2)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)",
ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l0_vals ^ 2, type <- "l", col <- "red")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1), lwd <- c(2, 2), col <- c("black", "red"), title <- "Lead Time 0")

#plot leadtime 4
max_y <- ceiling(max(c(obs_vals, ens_l4_vals ^ 2)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)",
ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l4_vals ^ 2, type <- "l", col <- "cyan")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1),
lwd <- c(2, 2), col <- c("black", "cyan"), title <- "Lead Time 4")

#plot leadtime 8
max_y <- ceiling(max(c(obs_vals, ens_l8_vals ^ 2)))
plot(day_vec, obs_vals, xaxt <- "n", ylab <- "PPT (mm)",
ylim <- c(0, max_y), type <- "l")
lines(day_vec, ens_l8_vals ^ 2, type <- "l", col <- "green")
legend("topleft", legend <- c("Observed", "Ensemble"), lty <- c(1, 1),
lwd <- c(2, 2), col <- c("black", "green"), title <- "Lead Time 8")
ticks <- seq(from <- min(day_vec), by <- "2 days", length <- (day_num[2] - day_num[1]+2)/2) 
lbl <- strftime(ticks, "%b-%d")
axis(side <- 1, outer <- TRUE, at <- ticks, labels <- lbl)
mtext("2008", side <- 1, outer <- TRUE, line <- 3, cex <- 1)
mtext("Hurricane Gustav Squared Ensemble Lead Time Comparison", side <- 3,
outer <- TRUE, line <- 1, cex <- 1.5)

## STATISTICS
mse <- rep(0, 3)
bias <- rep(0, 3)
association <- rep(0, 3)
skill <- rep(0, 3)
mse[1] <- sum((ens_l0_vals - obs_vals) ^ 2) / length(obs_vals)
bias[1] <- mean(ens_l0_vals) / mean(obs_vals)
association[1] <- (mean(obs_vals * ens_l0_vals) - mean(obs_vals) * mean(ens_l0_vals)) / sd(obs_vals) / sd(ens_l0_vals) 
skill[1] <- 1 - mse[1] / (sd(obs_vals) ^ 2)
mse[2] <- sum((ens_l4_vals - obs_vals) ^ 2) / length(obs_vals)
bias[2] <- mean(ens_l4_vals) / mean(obs_vals) 
association[2] <- (mean(obs_vals * ens_l4_vals) - mean(obs_vals)*mean(ens_l4_vals))/sd(obs_vals)/sd(ens_l4_vals) 
skill[2] <- 1 - mse[2] / (sd(obs_vals) ^ 2)
mse[3] <- sum((ens_l8_vals - obs_vals) ^ 2) / length(obs_vals)
bias[3] <- mean(ens_l8_vals) / mean(obs_vals)
association[3] <- (mean(obs_vals * ens_l8_vals) - mean(obs_vals)*mean(ens_l8_vals))/sd(obs_vals)/sd(ens_l8_vals) 
skill[3] <- 1 - mse[3] / (sd(obs_vals) ^ 2)
