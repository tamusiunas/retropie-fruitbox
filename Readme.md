# Retropie-Fruitbox
## This project installs [fruitbox jukebox](https://github.com/chundermike/rpi-fruitbox) on [Retropie](https://retropie.org.uk)

### To install

- Open a ssh session for Retropie using user pi and type:

```bash
wget https://raw.githubusercontent.com/tamusiunas/retropie-fruitbox/main/install-fruitbox-on-retropie.bash -O - | bash
```

- Songs (mp3) must be uploaded to /home/pi/RetroPie/roms/fruitbox/Music
- Config files (/home/pi/RetroPie/roms/fruitbox/fruitbox-config-buttons.sh and /home/pi/RetroPie/roms/fruitbox/fruitbox-test-buttons.sh) can be deleted after buttons configuration