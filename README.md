# resize-performancetest
Test-Script um den Performance-Unterschied zwischen "GDAL" und "Imagemagick" beim Verkleinern von Bildern zu zeigen.

GDAL ist eigentlich ein Programm zur Berarbeitung von Bilddaten für Geoinformationssysteme: http://www.gdal.org/

Das tolle daran ist aber, dass es extrem performant im Umgang mit großen Datenmengen ist. Allerdings benötigt ein Geoinformationssystem eigentlich stets korrekte Geo-Informationen in den Metadaten des Bildes. Wenn man jedoch einem klassischen JPG irgendwelche Dummy-Daten einpflanzt, ist eine Weiterverarbeitung mit GDAL auch bei digitalen Fotografien möglich.

Auf die Idee bin ich gekommen, als ich die BMNG-Daten der NASA bearbeitet habe, und drauf gekommen bin, dass Imagemagick dabei alles andere als performant damit umgeht. Ein Bild mit 86400x43200 Pixel mit Imagemagick zu verkleinern und in ein TIFF zu speichern geht dann zB schon allein aufgrund der Dateigröße von über 4.3GB nicht (Grenze von 4.3GB bei Ausgabe von TIFF mit IM). Daher die Idee, das Verkleinern zuerst mit GDAL zu erledigen, und dieses Ausgabe (GEOTiff) mit Imagemagick ins JPG/PNG/wasauchimmer zu konvertieren.

Überraschenderweise braucht diese Variante bei einem "normalen" digitalen Foto nur etwa 30% der (realen) Bearbeitungszeit im Vergleich zu Imagemagick und lässt sich auf (Debian-)Server unkompliziert implementieren.

lg, Stephan
