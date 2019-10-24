#!/bin/bash
#GDAL Module to prepare Flood Inundation Depth of Kulkandi Region
#Developed by Nishan Kumar Biswas, nbiswas@uw.edu
#Department of CEE, University of Wshington
#Graduate Research Assistant, SASWE REsearch Group 

#Remove all previous records and files
for((i=0; i<9; i+=1))
do
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:3857 ./inundation/FloodDepth/FD_Day0$i.tiff ./reproject/reproj$i.tiff
gdaldem color-relief ./reproject/reproj$i.tiff color.txt -alpha ./color/color$i.tiff
gdal2tiles.py -z 5-17 -g  ./color/color$i.tiff ./day$i/
done
