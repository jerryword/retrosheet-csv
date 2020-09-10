#!/usr/bin/env bash

# Append filename and line number to csv records
for file in csv/*.csv
do
  echo "Appending ${file##*/}"
  gawk -i inplace '
    function basename(file) {
      sub(".*/", "", file)
      return file
    }
    {
    { gsub(/\n/, ",") }
    if (FNR==1) 
      { print $0 "FILENAME_TX" "\",\"" "LINE_NUMBER_CT" "\"\n" }
      else { print $0 basename(FILENAME) "\"," FNR "\n" }
    }
' $file
done
