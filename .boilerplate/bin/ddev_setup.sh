#!/bin/bash

if ! command -v ddev &> /dev/null; then
    echo "\033[31mDDEV not found. Please install DDEV first.\033[0m";
    exit 1;
fi

echo "Setting up DDEV...";

exit 0;