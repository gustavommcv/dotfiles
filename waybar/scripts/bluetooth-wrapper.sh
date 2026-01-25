#!/bin/bash

IS_BLOCKED=$(rfkill list bluetooth | grep "Soft blocked: yes")

if [ ! -z "$IS_BLOCKED" ]; then
    rfkill unblock bluetooth
fi

foot bluetui
