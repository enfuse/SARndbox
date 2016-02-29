#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Get shell directory
DEST_SHADER=$DIR"/share/SARndbox-1.6/Shaders/SurfaceAddWaterColor.fs" # Destination shader path

PIPE_PATH=$DIR"/Control.fifo";
if [ ! -e $PIPE_PATH ] # Ensure that a control pipe is available
	then
		echo "Control.fifo not found."
		echo "Run 'mkfifo Control.fifo' and pass it to SARndbox via -cp flag"
		echo "./SARndbox <usual parameters> -cp "$PIPE_PATH
		exit 1
fi

shopt -s nocasematch # Case insensitive patterns
case $1 in
	water | w)
		SOURCE_SHADER=$DIR"/share/SARndbox-1.6/Shaders/Fluids/SurfaceAddWaterColor-Water.fs"
		echo "waterAttenuation 0.0078125" > $PIPE_PATH # 1/128
		;;
	lava | l)
		SOURCE_SHADER=$DIR"/share/SARndbox-1.6/Shaders/Fluids/SurfaceAddWaterColor-Lava.fs"
		echo "waterAttenuation 0.99" > $PIPE_PATH
		;;
	toxicwaste | tw)
		SOURCE_SHADER=$DIR"/share/SARndbox-1.6/Shaders/Fluids/SurfaceAddWaterColor-ToxicWaste.fs"
		echo "waterAttenuation 0.3" > $PIPE_PATH
		;;
	grayscale | g)
		SOURCE_SHADER=$DIR"/share/SARndbox-1.6/Shaders/Fluids/SurfaceAddWaterColor-Grayscale.fs"
		echo "waterAttenuation 0.05" > $PIPE_PATH
		;;
	*)
		echo "Fluid shader not found."
		echo "Available fluids are: Water, Lava, Toxic Waste, Grayscale"
		echo "Fluids may also be passed by first initial e.g. Water as w, Toxic Waste as tw"
		exit 1
		;;
esac

cp $SOURCE_SHADER $DEST_SHADER # Copy new fluid to active shader