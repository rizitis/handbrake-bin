#!/bin/bash

# Directory where the real libraries are located
LIB_DIR="/usr/lib64"

# Destination directory where symlinks will be created
DEST_DIR="/opt/handbrake-bin/libs"

# List of libraries we want to search for (library name without version)
LIB_NAMES=("libtheoradec.so" "libtheoraenc.so" "libass.so" "libavcodec.so" "libavfilter.so" "libavformat.so" "libavutil.so" "libbluray.so" "libdvdnav.so" "libdvdread.so" "libjansson.so" "libSvtAv1Enc.so" "libswresample.so" "libswscale.so" "libturbojpeg.so" "libva-drm.so" "libva.so" "libvorbis.so" "libvorbisenc.so" "libvpl.so" "libx264.so" "libx265.so" "libxml2.so")

# Define the desired symlink version for each library (e.g., ["libtheoradec.so"]="2")
declare -A LIB_SYMLINK_VERSIONS
LIB_SYMLINK_VERSIONS=(
    ["libtheoradec.so"]="1"
    ["libtheoraenc.so"]="1"
    ["libass.so"]="1"
    ["libavcodec.so"]="7"
    ["libavfilter.so"]="7"
    ["libavformat.so"]="7"
    ["libavutil.so"]="7"
    ["libbluray.so"]="1"
    ["libdvdnav.so"]="4"
    ["libdvdread.so"]="4"
    ["libjansson4.so"]="2"
    ["libSvtAv1Enc.so"]="2"
    ["libswresample.so"]="7"
    ["libswscale.so"]="7"
    ["libturbojpeg.so"]="1"
    ["libva-drm.so"]="1"
    ["libva.so"]="1"
    ["libvorbis.so"]="1"
    ["libvorbisenc.so"]="1"
    ["libvpl.so"]="1"
    ["libx264.so"]="164"
    ["libx265.so"]="215"
    ["libxml2.so"]="2"
)

# Loop through each library in the LIB_NAMES list
for LIB_NAME in "${LIB_NAMES[@]}"; do
    # Get the user-defined version for symlink (e.g., 2 for libtheoradec.so)
    SYMLINK_VERSION="${LIB_SYMLINK_VERSIONS[$LIB_NAME]}"

    # Find all real library files matching the pattern for the library (e.g., libtheoradec.so.*)
    REAL_LIBS=($(find "$LIB_DIR" -maxdepth 1 -type f -name "$LIB_NAME.*" | sort -V))

    # Check if we found any real libraries
    if [[ ${#REAL_LIBS[@]} -eq 0 ]]; then
        echo "Error: No real library files found for $LIB_NAME in $LIB_DIR."
        continue  # Skip to the next library
    fi

    # Get the highest available real version (last one in sorted list)
    REAL_LIB="${REAL_LIBS[-1]}"  # Latest version (e.g., libtheoradec.so.2.1.1)

    # Create symlink in the current directory with the user-defined version (e.g., libtheoradec.so.2)
    ln -sfn "$REAL_LIB" "$DEST_DIR/$LIB_NAME.$SYMLINK_VERSION"

    # Create a generic symlink (libtheoradec.so -> libtheoradec.so.2)
    ln -sfn "$DEST_DIR/$LIB_NAME.$SYMLINK_VERSION" "$DEST_DIR/$LIB_NAME"

    # Print the created symlinks
    echo "Symlinks created for $LIB_NAME in $DEST_DIR:"
    ls -l "$DEST_DIR/$LIB_NAME"*
    echo "-----------------------------"
done
