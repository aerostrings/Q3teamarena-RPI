#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="teamarena"
rp_module_desc="Quake 3 Team Arena - Official mission pack for Quake 3."
rp_module_licence="GPL2 https://raw.githubusercontent.com/raspberrypi/quake3/master/COPYING.txt"
rp_module_help="Add the pak files (pak0.pk3, pak1.pk3, pak2.pk3 and pak3.pk3) from your Quake 3 Team Arena installation to $romdir/ports/teamarena"
rp_module_section="exp"
rp_module_flags="!x86 !mali !kms"

function depends_teamarena() {
    getDepends libsdl1.2-dev libraspberrypi-dev
}

function sources_teamarena() {
    gitPullOrClone "$md_build" https://github.com/raspberrypi/quake3.git
}

function build_teamarena() {
    ./build_rpi_raspbian.sh
}

function install_teamarena() {
    md_ret_files=(
        'build/release-linux-arm/ioq3ded.arm'
        'build/release-linux-arm/ioquake3.arm'
    )
}

function game_data_teamarena() {
    if [[ ! -f "$romdir/ports/quake3/pak0.pk3" ]]; then
        downloadAndExtract "$__archive_url/Q3DemoPaks.zip" "$romdir/ports/quake3" -j
    fi
    chown -R $user:$user "$romdir/ports/quake3"
}

function configure_teamarena() {
    addPort "$md_id" "teamarena" "Quake III Team Arena" "LD_LIBRARY_PATH=lib $md_inst/ioquake3.arm +set fs_game missionpack"

    mkRomDir "ports/quake3"
    mkRomDir "ports/teamarena"

    moveConfigDir "$md_inst/baseq3" "$romdir/ports/quake3"
    moveConfigDir "$md_inst/missionpack" "$romdir/ports/teamarena"

    [[ "$md_mode" == "install" ]] && game_data_teamarena
}
