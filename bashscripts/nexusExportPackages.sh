#! /bin/bash

filters=("\\.nupkg$" "\\.pom$" "\\.zip$")
sourceServer=https://wlideploypw01.asia.intl.cigna.com:8444
sourceRepo=nuget-hosted
sourceUser=***
sourcePassword=***
logfile=$sourceRepo-backup.log
outputFile=$sourceRepo-artifacts.txt
# ======== GET DOWNLOAD URLs =========
url=$sourceServer"/service/rest/v1/assets?repository="$sourceRepo
contToken="initial"
while [ ! -z "$contToken" ]; do
    if [ "$contToken" != "initial" ]; then
        url=$sourceServer"/service/rest/v1/assets?continuationToken="$contToken"&repository="$sourceRepo
    fi
    echo Processing repository token: $contToken | tee -a $logfile
    response=`curl -ksSL -u "$sourceUser:$sourcePassword" -X GET --header 'Accept: application/json' "$url"`
    artifacts=( $(echo $response | sed -n 's|.*"downloadUrl" : "\([^"]*\)".*|\1|p') )
    printf "%s\n" "${artifacts[@]}" > artifacts.temp
    for filter in "${filters[@]}"; do
        cat artifacts.temp | grep "$filter" >> $outputFile
    done
    contToken=( $(echo $response | sed -n 's|.*"continuationToken" : "\([^"]*\)".*|\1|p') )
done



# ======== DOWNLOAD EVERYTHING =========
    echo Downloading artifacts...
    urls=($(cat $outputFile)) > /dev/null 2>&1
    for url in "${urls[@]}"; do
        path=${url#http://*:*/*/*/}
        dir=$sourceRepo"/"${path%/*}
        mkdir -p $dir
        cd $dir
        curl -vks -u "$sourceUser:$sourcePassword" -D response.header -X GET "$url" -O  >> /dev/null 2>&1
        responseCode=`cat response.header | sed -n '1p' | cut -d' ' -f2`
        if [ "$responseCode" == "200" ]; then
            echo Successfully downloaded artifact: $url  | tee -a $logfile 2>&1
        else
            echo ERROR: Failed to download artifact: $url  with error code: $responseCode  | tee -a $logfile 2>&1
        fi
        rm response.header > /dev/null 2>&1
        cd $curFolder
    done
