file_name=WaterHeight_`date +"%Y%m%d"`.csv
if [ -f file_name ]
then
echo $file_name
rm ./inundation/WaterHeight.csv
cp $file_name ./inundation/WaterHeight.csv
cd ./inundation
./FloodMap.sh
cd ..
./TileMaker.sh
fi

