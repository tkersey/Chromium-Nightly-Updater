#!/bin/bash

LATEST=`curl -s http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE`
CURRENT=`defaults read /Applications/Chromium.app/Contents/Info SVNRevision 2>/dev/null`
PROCESSID=`ps ux | awk '/Chromium/ && !/awk/ {print $2}'`

if [[ $LATEST -eq $CURRENT ]]; then
  echo "You're already up to date ($LATEST)"
  exit 0
fi
if [ "${PROCESSID[0]}" ];  then
  echo "Kill current instance of Chromium.app [y/n]"
  read -n 1 -s confirmation
fi
if [ "$confirmation" = "y" ];  then
  for x in $PROCESSID; do
    kill -9 $x
  done
else
  if [ $confirmation ]; then
    echo "Please close Chromium.app and restart the script"
    exit 0
  fi
fi

echo "Getting the latest version ($LATEST)"
curl -L "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/$LATEST/chrome-mac.zip" -o /tmp/chrome-mac.zip
wait

echo "Unzipping"
unzip -o -qq /tmp/chrome-mac.zip -d /tmp
wait

echo "Remove existing version"
rm -Rf /Applications/Chromium.app
wait

echo "Moving new version"
cp -R /tmp/chrome-mac/Chromium.app /Applications
wait

echo "Cleaning up"
rm -rf /tmp/chrome-*
echo "Done"
exit 0
