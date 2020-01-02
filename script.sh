#/bin/bash

set -e

working_dir=$(dirname $0)
tmp_dir=$working_dir/tmp-build
apktool=$working_dir/lib/apktool.sh
zipalign=$working_dir/lib/zipalign
apksigner=$working_dir/lib/apksigner

chmod +x $apktool
chmod +x $working_dir/lib/apksigner
chmod +x $working_dir/lib/zipalign

# decompile <apk>
filename=${1%.apk}
target_apk=$filename.apk
$apktool d -f "$target_apk" -o $tmp_dir


# apply patches

patches=`ls $working_dir/patches/*.patch`
for patchFile in $patches
do
  patch -u -d $tmp_dir -p0 < $patchFile
done

# create signing key

unaligned_output_apk_name=output.unaligned.apk

$apktool empty-framework-dir  
$apktool b -f $tmp_dir -o $unaligned_output_apk_name

$zipalign -v 4 $unaligned_output_apk_name output-unsigned.apk
cp output-unsigned.apk output-signed.tmp

$apksigner sign --ks ~/.android/debug.keystore --ks-key-alias androiddebugkey --ks-pass pass:android output-signed.tmp
mv output-signed.tmp output-signed.apk

rm $unaligned_output_apk_name
rm -r $tmp_dir
