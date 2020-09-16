#!/usr/bin/env bash

# Parse retrosheet event files
dirs=(~/retrosheet/event/asg 
  ~/retrosheet/event/post 
  ~/retrosheet/event/regular)
outdir=~/retrosheet-csv/csv
touch team
for dir in ${dirs[@]} 
do
  for file in $dir/*
  do
    if [[ $file =~ EV.$|ED.$ ]]
    then
    echo "Processing ${file##*/}"
      /usr/local/bin/cwgame -q -f 0-83 -x 0-94 -n $file > $outdir/${file##*/}.${dir##*/}.game.csv
      /usr/local/bin/cwevent -q -f 0-96 -x 0-62 -n $file > $outdir/${file##*/}.${dir##*/}.event.csv
      /usr/local/bin/cwcomment -q -n -f 0-2 $file > $outdir/${file##*/}.${dir##*/}.comment.csv 
      /usr/local/bin/cwsub -q -n $file > $outdir/${file##*/}.${dir##*/}.sub.csv
      /usr/local/bin/cwdaily -q -n $file > $outdir/${file##*/}.${dir##*/}.daily.csv
    elif [[ $file =~ EB.$ ]]
    then
    echo "Processing ${file##*/}"
    /usr/local/bin/cwdaily -q -n $file > $outdir/${file##*/}.${dir##*/}.daily.csv
    else
      continue
    fi
  done
done
rm team

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
      { print $0 ",\"" "FILENAME_TX" "\",\"" "LINE_NUMBER_CT" "\"" }
      else { print $0 ",\"" basename(FILENAME) "\"," FNR  }
    }
' $file
done
