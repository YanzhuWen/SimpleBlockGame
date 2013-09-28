#!/bin/sh
payload_dir="$CONFIGURATION_BUILD_DIR/Payload"
app_bundle_dir="$CONFIGURATION_BUILD_DIR/${PROJECT_NAME}.app"
/bin/rm -rf "$payload_dir"
/bin/mkdir "$payload_dir"
/bin/cp -R "$app_bundle_dir" "$payload_dir"
#/bin/cp iTunesArtwork "$CONFIGURATION_BUILD_DIR/iTunesArtwork"
cd "$CONFIGURATION_BUILD_DIR"
#/usr/bin/zip -r "${PROJECT_NAME}.ipa" Payload iTunesArtwork
/usr/bin/zip -r "${PROJECT_NAME}.ipa" Payload
rm -rf "$payload_dir" iTunesArtwork
