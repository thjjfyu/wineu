ndkver=25.1.8937393
android_target_api=28

#Put Termux x86_64 bin and lib inside this folder with all the wine dependencies
termux_folder=$HOME/termux_copy
mkdir -p $HOME/termux_files

export CC=$HOME/Android/Sdk/ndk/$ndkver/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android$android_target_api-clang
export CXX=$HOME/Android/Sdk/ndk/$ndkver/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android$android_target_api-clang++
export PKG_CONFIG_PATH=$termux_folder/lib/pkgconfig:$termux_folder/share/pkgconfig
export CPPFLAGS="-I$HOME/Android/Sdk/ndk/$ndkver/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I$termux_folder/include/"
export LDFLAGS="-L$termux_folder/lib"
export LIBRARY_PATH=$termux_folder/lib
export FREETYPE_CFLAGS="-I$termux_folder/include/freetype2"
export PULSE_LIBS="-L$termux_folder/lib -L$termux_folder/lib/pulseaudio -lpulse"
export SDL2_LIBS="-L$termux_folder/lib -lSDL2"
 
for arg in "$@"
do

	if [ "$arg" == "--configure" ]
	then
            echo -e "Configuring"
            ../configure --with-wine-tools=../wine-tools --host x86_64-linux-android$android_target_api --with-pulse --without-gstreamer --with-pthread --without-dbus --with-freetype --enable-wineandroid_drv=no --with-mingw --without-cups --without-v4l2 --enable-nls --disable-tests --without-capi --without-coreaudio --without-gettext --with-gettextpo=no --without-gphoto --without-inotify --without-netapi --without-opencl --without-oss --without-pcap --without-sane --without-udev --without-unwind --without-usb --without-xinerama --without-xshape --without-xshm --without-xxf86vm --enable-archs=x86_64,i386 --without-wayland --without-pcsclite --prefix $HOME/wine-build
        fi
	if [ "$arg" == "--build" ]
        then
            echo -e "Building"
            rm -rf $HOME/wine-build
            make -j4 install
            rm -rf $HOME/wine-build/include
        fi
        if [ "$arg" == "--compress" ]
        then
            echo -e "Compressing"
            rm -rf $HOME/wine-build.tar.xz
            tar -Jcf $HOME/wine-build.tar.xz -C $HOME wine-build
        fi
done
