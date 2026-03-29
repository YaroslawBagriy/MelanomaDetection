#!/usr/bin/env bash

# Run this script from the root directory
set -e

mkdir -p data/images/train data/images/val data/images/test

gdown --folder --remaining-ok  "https://drive.google.com/drive/folders/10xSPHYq54MgvqadB5mNusnruGTSEMDPn?usp=sharing" -O data/images/train
gdown --folder --remaining-ok  "https://drive.google.com/drive/folders/1WzggtnsWj68p2_o0qQYuNmM9BAvTXgCj?usp=sharing" -O data/images/val
gdown --folder --remaining-ok  "https://drive.google.com/drive/folders/1GLek8oiK1L0aBaiAvkHXcmjurTDb8bi2?usp=sharing" -O data/images/test

find data/images -maxdepth 2 -type d