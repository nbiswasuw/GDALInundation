#!/bin/bash
#GDAL Module to prepare Flood Inundation Depth of Kulkandi Region
#Developed by Nishan Kumar Biswas, nbiswas@uw.edu
#Department of CEE, University of Wshington
#Graduate Research Assistant, SASWE REsearch Group 

#Remove all previous records and files
rm *.dbf
rm *.shp
rm *.prj
rm *.shx
rm ./WaterSurface/*
rm ./FloodDepth/*
#Convert MIKE Output(CSV) into ESRI Shapefile, configuration is in CSVtoShp.vrt 
ogr2ogr -f "ESRI Shapefile" . Rainfall.csv && ogr2ogr -overwrite -f "ESRI Shapefile" . CSVtoShp.vrt

#Interpolate 1-8 day forecasted heights of different points and generate Raster Surface of Water Height 
gdal_rasterize -of GTiff -a RF -te 60.90 23.7 77.8 37.1 -tr 0.1 0.1 -a_srs EPSG:4326 Rainfall.shp -l Rainfall Test.tif


for((i=0; i<9; i+=1))
do
#Generating Water Surface Raster from the CSV File
gdal_grid -a invdist:power=2.0:smoothing=1.0 -txe 89.6497088 89.8165430 -tye 25.2006274 25.0542799 -outsize 3518 3086 -a_srs EPSG:4326 -zfield H$i -of GTiff -ot Float32 WaterSurface.shp -l WaterSurface ./WaterSurface/WS0$i.tiff

#Generate Flood Depth Surface by Subtracting DEM from the Water Surface Raster
gdal_calc.py -A ./WaterSurface/WS0$i.tiff -B ./DEM/Kulkandi_DEM.tif --outfile=./FloodDepth/FD_Day0$i.tiff --calc="A-B" --NoDataValue=9999

#Generate Flood Depth Surface by Subtracting DEM from the Water Surface Raster
#gdal_calc.py -A ./FloodDepth/FD_I0$i.tiff -B ./WeightRaster/FinalWeight.tif --outfile=./FloodDepth/FD_Day0$i.tiff --calc="A*B" --NoDataValue=9999

#Convert GeoTiff file into AAI Grid(ASCII Grid) file
#gdal_translate -of aaigrid -co DECIMAL_PRECISION=3 ./FloodDepth/FD_Day0$i.tiff ./Output_ASCII/FD_Day_0$i.asc
done

