#!/bin/bash

http -A bearer -a "$HA_TOKEN" POST "srv:8123/api/services/$1/toggle" entity_id="$2"
