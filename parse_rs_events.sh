#!/bin/bash

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
#      echo "GAME_ID,EVENT_ID,COMMENT_TX" > $outdir/${file##*/}.${dir##*/}.comment.csv
      /usr/local/bin/cwcomment -q -f 0-2 $file >> $outdir/${file##*/}.${dir##*/}.comment.csv 
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
