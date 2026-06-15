#!/bin/bash
# Run this script after importing new APK prebuilts.

REL_PATH="device/xiaomi/miuicamera-marble"
LARGE_APKS="$(find prebuilts -type f -name "*.apk" -size +20M)"

rm -f vendorsetup.sh .gitignore
[ -z "$LARGE_APKS" ] && exit 0

touch vendorsetup.sh
chmod +x vendorsetup.sh

for f in $LARGE_APKS; do
    echo "splitting $f"

    rm -f "$f".part*

    split --bytes=20M -d "$f" "$f.part"

    echo "cat $REL_PATH/$f.part* > $REL_PATH/$f" >> vendorsetup.sh
    echo "$f" >> .gitignore
done

echo "cat vendor/xiaomi/miuicamera-marble/proprietary/system/priv-app/MiuiCamera/MiuiCamera.apk.part* > vendor/xiaomi/miuicamera-marble/proprietary/system/priv-app/MiuiCamera/MiuiCamera.apk" >> vendorsetup.sh
