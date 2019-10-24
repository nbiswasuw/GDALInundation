file_name=WaterHeight_`date +"%Y%m%d"`.csv
echo $file_name
rm ./inundation/WaterHeight.csv
cp $file_name ./inundation/WaterHeight.csv
cd ./inundation
./FloodMap.sh
cd ..
./TileMaker.sh
