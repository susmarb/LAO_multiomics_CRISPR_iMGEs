#!/bin/bash 

function pwait() {
    while [ "$(jobs -p | wc -l)" -ge $1 ]; do
        sleep 1
    done
}
