#!/usr/bin/env bash

if [[ -f /sys/kernel/mm/transparent_hugepage/enabled ]]; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

if [[ -f /sys/kernel/mm/transparent_hugepage/defrag ]]; then
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi

echo "ok=true changed=true"
