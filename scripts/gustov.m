% Sample Matlab code for determining scaling error for Hurricane Gustav
% you need to change all of the file names for the ensembles, the
% TRMM_peak, and Ens_peak day when running this

% Define peak days
TRMM_peak = 245;
Ens_peak = 15;

% open Ensemble files for forecast
Ens_file1 = 'CanCM4_EnsNo­1_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens1 = netcdf.open(Ens_file1);
% ncdisp(Ens_file1);
Ens_file2 = 'CanCM4_EnsNo­2_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens2 = netcdf.open(Ens_file2);
Ens_file3 = 'CanCM4_EnsNo­3_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens3 = netcdf.open(Ens_file3);
Ens_file4 = 'CanCM4_EnsNo­4_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens4 = netcdf.open(Ens_file4);
Ens_file5 = 'CanCM4_EnsNo­5_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens5 = netcdf.open(Ens_file5);
Ens_file6 = 'CanCM4_EnsNo­6_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens6 = netcdf.open(Ens_file6);
Ens_file7 = 'CanCM4_EnsNo­7_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens7 = netcdf.open(Ens_file7);
Ens_file8 = 'CanCM4_EnsNo­8_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens8 = netcdf.open(Ens_file8);
Ens_file9 = 'CanCM4_EnsNo­9_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens9 = netcdf.open(Ens_file9);
Ens_file10 = 'CanCM4_EnsNo­10_LeadTime­0_Hurricane­Gustav_20080818­20080914.nc';
Ens10 = netcdf.open(Ens_file10);

% open shape file
LA_borders_file = 'Louisiana.nc';
shape = netcdf.open('Louisiana.nc');
ncdisp(LA_borders_file)

% open TRMM files for observed
TRMM_file = 'prcp_trmm_2008.nc';
TRMM = netcdf.open(TRMM_file);
ncdisp(TRMM_file)

%extract values from matrices
Ens1_P = ncread(Ens_file1, 'Precipitation');
Ens2_P = ncread(Ens_file2, 'Precipitation');
Ens3_P = ncread(Ens_file3, 'Precipitation');
Ens4_P = ncread(Ens_file4, 'Precipitation');
Ens5_P = ncread(Ens_file5, 'Precipitation');
Ens6_P = ncread(Ens_file6, 'Precipitation');
Ens7_P = ncread(Ens_file7, 'Precipitation');
Ens8_P = ncread(Ens_file8, 'Precipitation');
Ens9_P = ncread(Ens_file9, 'Precipitation');
Ens10_P = ncread(Ens_file10, 'Precipitation');
shape = ncread(LA_borders_file, 'Louisiana');
TRMM_P = ncread(TRMM_file, 'precip ');

% find information on peak day for each ensemble
Ens1_P = Ens1_P(:, :, Ens_peak)';
Ens2_P = Ens2_P(:, :, Ens_peak)';
Ens3_P = Ens3_P(:, :, Ens_peak)';
Ens4_P = Ens4_P(:, :, Ens_peak)';
Ens5_P = Ens5_P(:, :, Ens_peak)';
Ens6_P = Ens6_P(:, :, Ens_peak)';
Ens7_P = Ens7_P(:, :, Ens_peak)';
Ens8_P = Ens8_P(:, :, Ens_peak)';
Ens9_P = Ens9_P(:, :, Ens_peak)';
Ens10_P = Ens10_P(:, :, Ens_peak)';
conc = cat(3, Ens1_P, Ens2_P, Ens3_P, Ens4_P, Ens5_P, Ens6_P, Ens7_P, Ens8_P, Ens9_P, Ens10_P);

%compute the average value of precipitation for each ensemble
Ens_P = mean(conc, 3);

% find information on peak day for TRMM
longitude = ncread(Ens_file1, ' longitude ');
latitude = ncread(Ens_file1, ' latitude ');
TRMM_P = TRMM_P(:, :, TRMM_peak)';

%mask Ensemble and TRMM with shapefile
data = shape > 0;
data = double(data);
data(data == 0) = NaN;
mask_Ens = data .* Ens_P;
mask_TRMM = data .* TRMM_P;

% Error difference between TRMM and Ensemble
Error = mask_TRMM ­mask_Ens; Max_Error = max(max(Error));
TRMM_max = max(max(mask_TRMM));
TRMM_max_location = find(TRMM_max == mask_TRMM);
Error_location = find(Max_Error == Error);
Max_Ens = mask_Ens(Error_location);
Max_TRMM = mask_TRMM(Error_location);
ratio = mask_TRMM ./ mask_Ens;

%plot figures for Observed, Forecasted, and Difference Between the Two figure(1)
s1 = subplot(2, 2, 1)
map = pcolor(longitude, latitude, mask_Ens);
xlabel('Longitude');
title('Forecast (All Ensembles)');
ylabel('Latitude');
hold on;
set(map, 'EdgeColor', 'none');
legend = colorbar;
title(legend, 'Precipitation (mm/day)');
grid off;
hold on;
s2 = subplot(2, 2, 2)
map = pcolor(longitude, latitude, mask_TRMM);
xlabel('Longitude');
title('Observed (TRMM)');
ylabel('Latitude');
hold on;
set(map, 'EdgeColor', 'none');
legend = colorbar;
title(legend, 'Precipitation (mm/day)');
s3 = subplot(2, 2, 3)
map = pcolor(longitude, latitude, ratio);
xlabel('Longitude');
title('Scaling Error (TRMM:Ensemble)');
ylabel('Latitude');
hold on;
set(map, 'EdgeColor', 'none');
legend = colorbar;
colormap(s3, hot);
s4 = subplot(2, 2, 4)
NOAA = imagesc(imread('Gustav.png'));
set(gca, 'xtick', [], 'ytick', []);
title('NOAA Hurricane Map');
