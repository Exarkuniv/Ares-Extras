#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="gmloader"
rp_module_desc="GMLoader - play GameMaker Studio games for Android on non-Android operating systems"
rp_module_help="ROM Extensions: .apk .APK\n\nIncludes free games Maldita Castilla and Spelunky Classic HD. Use launch scripts as template for additional games."
rp_module_repo="git https://github.com/JohnnyonFlame/droidports.git master faf3970"
rp_module_licence="GPL3 https://raw.githubusercontent.com/JohnnyonFlame/droidports/master/LICENSE.md"
rp_module_section="prt"
rp_module_flags="!all rpi4"

function depends_gmloader() {
    getDepends libopenal-dev libfreetype6-dev zlib1g-dev libbz2-dev libpng-dev libzip-dev libsdl2-image-dev cmake
}

function sources_gmloader() {
    gitPullOrClone "$md_build" https://github.com/JohnnyonFlame/droidports.git master
    # group config dirs in parent gmloader dir
    applyPatch "/home/aresuser/ARES-Setup/scriptmodules/ports/gmloader/01-config-dir.patch"
}

function build_gmloader() {
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DPLATFORM=linux -DPORT=gmloader ..
    make
    md_ret_require="$md_build/build/gmloader"
}

function install_gmloader() {
    md_ret_files=('build/gmloader')
}

function configure_gmloader() {
    mkRomDir "ports/droidports"
    if [[ "$md_mode" == "install" ]]; then
      
     if  [[ ! -f "$romdir/ports/droidports/Maldita_Castilla_ouya.apk" ]]; then 
    downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/Maldita.zip" "$romdir/ports/droidports"

     elif [[ ! -f "$romdir/ports/droidports/spelunky_classic_hd-android.apk" ]]; then
    downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/spelunky.zip" "$romdir/ports/droidports"
   fi

  fi

    addPort "$md_id" "droidports" "Maldita Castilla" "$md_inst/gmloader %ROM%" "$maldita_file"
    addPort "$md_id" "droidports" "Spelunky Classic HD" "$md_inst/gmloader %ROM%" "$spelunky_file"

    if [[ -f "$romdir/ports/droidports/am2r_155.apk" ]]; then
       addPort "$md_id" "droidports" "AM2R - Another Metroid 2 Remake" "$md_inst/gmloader %ROM%" "$am2r_file"
    fi

    #moveConfigDir "$home/.config/gmloader" "$md_conf_root/droidports"
}