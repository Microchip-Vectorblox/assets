VER="${1:-2.0.2}"
YOCTO=5.15.92-linux4microchip+fpga-2023.02.1

if [[ $(uname -r) != $YOCTO ]]; then
	echo "Improper Yocto Version detected, VectorBlox demo might not function as intended."
	exit
fi

#Setup camera if not found
if [ -d release-v$VER ]; then
	cd release-v$VER/example/soc-video-c
	if [ ! -f /opt/microchip/auto_gain ]; then
		bash setup_camera.sh
	fi
fi

if [ ! -d samples_V1000_$VER ]; then
	wget --no-check-certificate https://github.com/Microchip-Vectorblox/VectorBlox-SoC-Video-Kit-Demo/releases/download/release-v$VER/samples_V1000_$VER.zip ~

	unzip samples_V1000_$VER.zip
fi

if [ ! -d release-v$VER ]; then
	wget --no-check-certificate https://github.com/Microchip-Vectorblox/VectorBlox-SDK/archive/refs/tags/release-v$VER.zip ~

	unzip release-v$VER.zip
fi