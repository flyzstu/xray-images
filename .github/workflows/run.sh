#!/bin/bash
GH_REPOSITORIES="XTLS/Xray-core"
GH_REPOSITORIES_API="https://api.github.com/repos/${GH_REPOSITORIES}/releases/latest"

message=`curl $GH_REPOSITORIES_API`
echo $message | jq .tag_name
