#!/bin/sh

buildPath=`pwd`
arch="Release"
target="React"
projectPath="Pods/Pods.xcodeproj"
hederFile="Include"


if [ "$1" == "Debug" ]; then
	arch="Debug"
fi

if [ "$2" == "Yoga" ]; then
	target="Yoga"
fi

#编译i386 x86_64
xcodebuild -project ${buildPath}/${projectPath} -target $target OTHER_CFLAGS="-fembed-bitcode" ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator VALID_ARCHS="x86_64 i386" -configuration $arch clean build

cp ${buildPath}/build/${arch}-iphonesimulator/${target}/lib${target}.a ./lib_i386_x86.a

#编译armv7 arm64
xcodebuild -project ${buildPath}/${projectPath} -target $target BITCODE_GENERATION_MODE=bitcode ONLY_ACTIVE_ARCH=NO -sdk iphoneos VALID_ARCHS="armv7 arm64" -configuration $arch clean build

cp ${buildPath}/build/${arch}-iphoneos/$target/lib${target}.a ./lib_armv7_arm64.a

lipo -create ${buildPath}/lib_i386_x86.a ${buildPath}/lib_armv7_arm64.a -output ./lib${target}.a

EXCODE=$?
if [ "$EXCODE" != "0" ]; then
	echo "\033[41;37m 生成.a文件失败 \033[0m"
        exit 1
fi

rm ./lib_i386_x86.a ./lib_armv7_arm64.a

rm ./${target}${arch}/*.a
rm ./${target}Include/*.h

mv ./lib${target}.a ./${target}${arch}/lib${target}.a

cp ${buildPath}/build/${arch}-iphoneos/$target/*.h ./${target}Include
rm -rf ./build

cd ./${target}Include
./updateReactHeaderFiles.sh
cd ..
