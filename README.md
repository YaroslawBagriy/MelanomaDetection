# Melanoma Detection and Image Regeneration

Vision AI final team project for the University of St. Thomas focused on detecting melanoma from dermoscopic skin lesion images using the ISIC 2020 dataset, and using the analysis to generate new images. 

## Overview

Melanoma is one of the most serious forms of skin cancer, but it can often be treated successfully when detected early. In this project, our team explores computer vision and deep learning methods for binary classification of skin lesion images as benign or malignant.

In addition to classification, we are also interested in generative approaches such as Variational Autoencoders (VAEs) to better understand lesion representations, explore latent space, and potentially generate synthetic malignant examples for experimentation and class balance research.

## Project Goals

- Build a binary image classification model to predict whether a skin lesion is benign or malignant
- Explore class imbalance challenges in melanoma detection
- Investigate generative modeling approaches such as VAEs
- Study latent space representations of malignant skin lesions
- Evaluate whether synthetic image generation may support model development
- Create a professional, reproducible GitHub portfolio project

## Dataset

**Dataset:** ISIC 2020 Challenge Dataset  
**Source:** [ISIC 2020 Challenge](https://challenge2020.isic-archive.com/)

We are using a dataset originally prepared for the ISIC 2020 Kaggle challenge. It contains dermoscopic images of benign and malignant skin lesions reviewed by experts and medical professionals.

### Dataset Summary

- **Number of records:** 33,126
- **Number of attributes:** 8
- **Unique patients:** 2,056

### Attributes

- **image_name**: image file name (`.jpg`)
- **patient_id**: patient identifier
- **sex**: categorical (`male`, `female`)
- **age_approx**: approximate age, numerical
- **anatom_site_general_challenge**: anatomical site of lesion
- **diagnosis**: diagnosis type
- **benign_malignant**: categorical (`benign`, `malignant`)
- **target**: binary target (`0` = benign, `1` = malignant)

## General Dataset Statistics

### Shape

- **Total rows:** 33,126
- **Total columns:** 8

### Age (`age_approx`)

- **Non-missing:** 33,058
- **Missing:** 68
- **Mean:** 48.87
- **Standard deviation:** 14.38
- **Median:** 50
- **Min:** 0
- **Max:** 90

### Sex Distribution

- **Male:** 17,080 (51.56%)
- **Female:** 15,981 (48.24%)
- **Missing:** 65 (0.20%)

### Benign vs Malignant

This dataset is highly imbalanced.

- **Benign:** 32,542 (98.24%)
- **Malignant:** 584 (1.76%)

### Diagnosis Distribution

- **unknown:** 27,124 (81.88%)
- **nevus:** 5,193 (15.68%)
- **melanoma:** 584 (1.76%)
- **seborrheic keratosis:** 135 (0.41%)
- **lentigo NOS:** 44 (0.13%)
- **lichenoid keratosis:** 37 (0.11%)
- **solar lentigo:** 7 (0.02%)
- **cafe-au-lait macule:** 1
- **atypical melanocytic proliferation:** 1

### Anatomical Site Distribution

- **torso:** 16,845 (50.85%)
- **lower extremity:** 8,417 (25.41%)
- **upper extremity:** 4,983 (15.04%)
- **head/neck:** 1,855 (5.60%)
- **palms/soles:** 375 (1.13%)
- **oral/genital:** 124 (0.37%)
- **Missing:** 527 (1.59%)

## Sample Research Questions

Our team plans to explore the following questions:

1. Can a deep learning model accurately classify skin lesions as benign or malignant?
2. How does severe class imbalance affect melanoma detection performance?
3. Can generative models such as VAEs help us better understand malignant lesion structure?
4. Can synthetic image generation support experimentation for rare melanoma cases?
5. Can latent space walking help visualize progression-like changes in lesions?
6. Can image-based features be combined with metadata for improved prediction?

## Tools and Platforms

We plan to use:

- GitHub
- Google Colab
- Jupyter Notebook
- Python
- PyTorch
- OpenCV
- Scikit-learn
- Matplotlib / Seaborn
- Variational Autoencoders (VAE)
- Convolutional Neural Networks (CNN)

## Methods

Our project may include some or all of the following:

- Image preprocessing and normalization
- Exploratory data analysis
- Binary image classification
- CNN-based modeling
- Model evaluation using classification metrics
- Handling class imbalance
- Generative modeling with VAEs
- Latent space interpolation / walking
- Optional metadata integration with image features

## Repository Structure

```text
MelanomaDetection/
│
├── data/
│   ├── raw/
│   ├── processed/
│
├── notebooks/
│   ├── 01_data_exploration.ipynb
│   ├── 02_preprocessing.ipynb
│   ├── 03_model_training.ipynb
│   ├── 04_evaluation.ipynb
│   └── 05_vae_experiments.ipynb
│
├── src/
│   ├── data_loader.py
│   ├── preprocessing.py
│   ├── train.py
│   ├── evaluate.py
│   └── models.py
│
├── outputs/
│   ├── figures/
│   ├── models/
│   └── reports/
│
├── requirements.txt
├── .gitignore
└── README.md
