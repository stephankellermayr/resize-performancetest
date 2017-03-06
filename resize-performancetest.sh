#!/bin/bash
# 
# Performance-Test: GDAL vs. ImageMagick
#
# TODO: Die Ziel-Bildgröße (XxY) müsste bei GDAL manuell errechnet werden.
# Ausgehend vom Original und Hochformat/Querformat beachtend.
# echo $(identify -quiet -format '%wx%h' ${1} 2>/dev/null)
#

# Check arguments
[[ -z "${1}" ]] && { echo "Bitte Bild angeben: ./resize-performancetest.sh INPUT.JPG"; exit; }
[[ -f "${1}" ]] || { echo "Bild nicht gefunden :-("; exit; }

# Check programs
cmdGdalTranslate=$(which gdal_translate)
[ ${cmdGdalTranslate} ] || { echo "\"gdal_translate\" nicht gefunden. Bitte mit \"apt-get install gdal\" installieren."; exit; }
cmdGdalWarp=$(which gdalwarp)
[ ${cmdGdalWarp} ] || { echo "\"gdalwarp\" nicht gefunden. Bitte mit \"apt-get install gdal\" installieren."; exit; }
cmdConvert=$(which convert)
[ ${cmdConvert} ] || { echo "\"convert\" nicht gefunden. Bitte mit \"apt-get install imagemagick\" installieren."; exit; }

# Klassische Verkleinerung mit ImageMagick
function test_im() {
	$(which convert) -quiet "${1}" -resize 320x213 -strip -quality 85 output-im.jpg
}

# Verkleinern eines Fotos mit GDAL
function test_gdal() {
	# 1. Erzeuge intermediate mit GEO-Informationen
	${cmdGdalTranslate} -of VRT -a_srs WGS84 -a_ullr -180 90 0 -90 "${1}" gdal.vrt >/dev/null 2>&1
	# 2. Verkleinere das (vermeintliche) GeoTIFF
	${cmdGdalWarp} -ts 320 213 -of GTiff -r cubic gdal.vrt gdal.tif >/dev/null 2>&1
	# 3. Konvertiere das GEOTiff zurück ins JPG-Format
	${cmdConvert} -quiet gdal.tif -strip -quality 85 output-gdal.jpg
}

# Cleanup
[[ -f output-im.jpg ]] && rm output-im.jpg
[[ -f output-gdal.jpg ]] && rm output-gdal.jpg

echo -e "\nVerkleinern mit ImageMagick:"
time test_im "${1}"

echo -e "\nVerkleinern mit GDAL:"
time test_gdal "${1}"

# Lösche intermediates
[[ -f gdal.vrt ]] && rm gdal.vrt
[[ -f gdal.tif ]] && rm gdal.tif
