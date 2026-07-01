VER="${1:-3.1}"
COMP="${2:-NCOMP}"
YOCTO=5.15.92-linux4microchip+fpga-2023.02.1

if [[ $(uname -r) != $YOCTO ]]; then
	echo "Improper Yocto Version detected, VectorBlox demo might not function as intended."
	echo "Yocto Version: $YOCTO required"
	echo "Please download at https://github.com/polarfire-soc/meta-polarfire-soc-yocto-bsp/releases/download/v2023.02.1/core-image-minimal-dev-mpfs-video-kit-20230328105837.rootfs.wic.gz"
	exit
fi

if [ ! -d samples_V1000_${COMP}_${VER} ]; then
	if [ ! -f samples_V1000_${COMP}_${VER}.zip ]; then
		wget --no-check-certificate https://github.com/Microchip-Vectorblox/VectorBlox-SoC-Video-Kit-Demo/releases/download/release-v${VER}/samples_V1000_${COMP}_${VER}.zip ~
	fi
	unzip samples_V1000_${COMP}_${VER}.zip -d ~
fi

if [ ! -d VectorBlox-SDK-release-v$VER ]; then
	if [ ! -f release-v$VER.zip ]; then
		wget --no-check-certificate https://github.com/Microchip-Vectorblox/VectorBlox-SDK/archive/refs/tags/release-v$VER.zip ~
	fi
	if [ -f VectorBlox-SDK-release-v$VER.zip ]; then
		mv VectorBlox-SDK-release-v$VER.zip release-v$VER.zip
	fi
	unzip release-v$VER.zip -d ~
	
	cd VectorBlox-SDK-release-v$VER/example/soc-video-c
	bash setup_camera.sh
	cd -
fi

#Setup camera if not found
if [ -d VectorBlox-SDK-release-v$VER ]; then
	cd VectorBlox-SDK-release-v$VER/example/soc-video-c
	if [ ! -f /opt/microchip/auto_gain ]; then
		if [ ! -f setup_camera.sh ]; then
			wget --no-check-certificate https://github.com/Microchip-Vectorblox/assets/releases/download/assets/camera_setup.zip
			
			unzip camera_setup.zip
		fi
		bash setup_camera.sh
	fi
	
	if [ ! -f run-video-model ];then
		make overlay
		sed -i "s|-DNCOMP|-D$COMP|" Makefile
		make
		sed -i "s|-D$COMP|-DNCOMP|" Makefile
	fi
	
	if [ -f run-video-model ];then
		./run-video-model
	fi
fi