#!/bin/bash
. /etc/os-release
if [ "$VERSION_ID" != "10" ]
then
 echo "OS Version is not 10";
 exit;
fi
cd ~
git clone https://github.com/chundermike/rpi-fruitbox.git
cd rpi-fruitbox/build
sudo apt-get update
sudo apt-get install build-essential git cmake xorg-dev libgl1-mesa-dev libgles2-mesa-dev libglu-dev libdumb1 libjpeg-dev libfreetype6-dev libpng12-0 libpng-dev libasound-dev libxcursor-dev libvorbis-dev libtheora-dev libts-dev -y
tar -xvf mpg123-1.24.0.tar
cd mpg123-1.24.0
chmod +x configure
./configure --with-cpu=arm_fpu --disable-shared
make && sudo make install
cd /opt/vc/lib
sudo ln -s libbrcmEGL.so libEGL.so
sudo ln -s libbrcmGLESv2.so libGLESv2.so
sudo ln -s libbrcmOpenVG.so libOpenVG.so
sudo ln -s libbrcmWFC.so libWFC.so
cd ~/rpi-fruitbox/build
tar -xvf allegro-5.2.4.0.tar
cd allegro-5.2.4.0
mkdir build && cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchain-raspberrypi.cmake -DSHARED=off
make && sudo make install
cd ~/rpi-fruitbox/build
make

cd ~/rpi-fruitbox
find skins -name fruitbox.cfg -exec sh -c "sed -e 's/^\#\[joystick\]/\[joystick\]/' {} | sed -e 's/^MusicPath = \.\.\/Music\//MusicPath = \/home\/pi\/RetroPie\/roms\/fruitbox\/Music\//' | sed -e 's/^Database = \.\.\/fruitbox\.db/Database = \/home\/pi\/RetroPie\/roms\/fruitbox\/fruitbox.db/' | sed -e 's/^\#Bitmap = joystick.png/Bitmap = joystick.png/; w {}'" \;
cp /etc/emulationstation/es_systems.cfg ~/.emulationstation/es_systems.cfg
cd ~
cat .emulationstation/es_systems.cfg | sed -e "s/^<\/systemList>//; w .emulationstation/es_systems.cfg"
cat >>  ~/.emulationstation/es_systems.cfg <<EOF
  <system>
    <fullname>Fruitbox</fullname>
    <name>Fruitbox</name>
    <path>~/RetroPie/roms/fruitbox</path>
    <extension>.sh .SH</extension>
    <command>bash %ROM%</command>
    <platform>fruitbox</platform>
    <theme>fruitbox</theme>
  </system>
</systemList>
EOF
mkdir -p /home/pi/RetroPie/roms/fruitbox
cat > ~/RetroPie/roms/fruitbox/fruitbox.sh << EOF
cd ~/rpi-fruitbox
./fruitbox --cfg skins/NumberOne/fruitbox.cfg
EOF
cat > ~/RetroPie/roms/fruitbox/fruitbox-test-buttons.sh << EOF
cd ~/rpi-fruitbox
./fruitbox --test-buttons --cfg skins/NumberOne/fruitbox.cfg
EOF
cat > ~/RetroPie/roms/fruitbox/fruitbox-config-buttons.sh << EOF
cd ~/rpi-fruitbox
./fruitbox --config-buttons --cfg skins/NumberOne/fruitbox.cfg
EOF

chmod +x ~/RetroPie/roms/fruitbox/fruitbox.sh ~/RetroPie/roms/fruitbox/fruitbox-test-buttons.sh ~/RetroPie/roms/fruitbox/fruitbox-config-buttons.sh
sudo mkdir -p /etc/emulationstation/themes/carbon/fruitbox/art
sudo cp /etc/emulationstation/themes/carbon/kodi/theme.xml /etc/emulationstation/themes/carbon/fruitbox/
mkdir -p ~/.emulationstation/gamelists/fruitbox
cat > ~/.emulationstation/gamelists/fruitbox/gamelist.xml <<EOF
<?xml version="1.0"?>
<gameList>
        <game>
                <path>./fruitbox.sh</path>
                <name>fruitbox</name>
                <desc>MP3 Jukebox Software</desc>
                <image>/home/pi/.emulationstation/downloaded_images/fruitbox/fruitbox-image.png</image>
                <playcount></playcount>
                <lastplayed></lastplayed>
        </game>
</gameList>
EOF
mkdir -p ~/.emulationstation/downloaded_images/fruitbox
mkdir -p ~/RetroPie/roms/fruitbox/Music
echo “#”
echo “# Reboot the system”
echo “#”