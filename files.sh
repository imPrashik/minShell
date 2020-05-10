#!/bin/bash
#©Prashik@Agile
clear
echo ©Prashik @Agile
echo
if [ ! -d ./files ]; then
  mkdir -p "./files"
fi
if [ ! -d ./min ]; then
  mkdir -p "./min"
fi
rm -rf min/*
find . -maxdepth 1 \( ! -name '*.sh' -a ! -name '*.jar' -a ! -name '*.docx' -a ! -name 'files' -a ! -name 'min' \) | while read files; do
  if [ "$files" != '.' ]; then
  mvfiles="${files#./}"
  mv "$files" "./files/$mvfiles"
  fi
done
find ./files \( ! -name '*.min.js' -a -name '*.js' \) -o \( ! -name '*.min.css' -a -name '*.css' \) -type f | while read file; do
  dir=$(dirname "${file}")
  minh=${dir#./files}
  mkdir -p "./min$minh"
  extension="${file##*.}"
  if [ "$extension" = 'js' ]; then
  tfile="${file/.js/.min.js}"
  tfile=${tfile#./files}
  status=`java -jar min.jar "$file" -o "./min$tfile" 2>&1`
  if [ "$status" = '' -a -f "./min$tfile" ]; then
    echo $file Compression Successful
  else
    echo $file Compression Failed
    echo -ne $"File=> $file\r\n" >> ./min/errorlog.txt
    echo  -ne $"Error=>\r\n$status\r\n\r\n" >> ./min/errorlog.txt
  fi
  elif [ "$extension" = 'css' ]; then
  tfile="${file/.css/.min.css}"
  tfile=${tfile#./files}
  status=`java -jar min.jar "$file" -o "./min$tfile" 2>&1`
  if [ "$status" = '' -a -f "./min$tfile" ]; then
    echo $file Compression Successful
  else
    echo $file Compression Failed
    echo -ne $"File=> $file\r\n" >> ./min/errorlog.txt
    echo  -ne $"Error=>\r\n$status\r\n\r\n" >> ./min/errorlog.txt
  fi
  fi
done
if [ -f ./min/errorlog.txt ]; then
  echo
  echo Compression Failure info available in ./min/errorlog.txt
fi
echo