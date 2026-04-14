# CNN Notebook Guide

This folder contains the CNN workflow used for binary melanoma classification.

Current notebook:

- [CNN_discovery.ipynb](/Users/chance/Documents/grad-school/MelanomaDetection/notebooks/CNN/CNN_discovery.ipynb)

## Loading The Model

This director contains a `.keras` file - update the file path below with where you have it saved (most likley Google Drive).

```python
import tensorflow as tf

model = tf.keras.models.load_model(
    "/content/drive/MyDrive/../melanoma_cnn_arch1_35epochs.keras"
)
```

## Required Preprocessing

Images should be preprocessed the same way they were during training:

- resize to `224 x 224`
- convert to `float32`
- scale pixel values to `[0, 1]`
- add a batch dimension before prediction

## Single-Image Prediction Example

```python
import tensorflow as tf
import numpy as np

IMG_SIZE = (224, 224)
THRESHOLD = 0.5

def preprocess_image(image_path):
    img = tf.keras.utils.load_img(image_path, target_size=IMG_SIZE)
    img = tf.keras.utils.img_to_array(img)
    img = img.astype("float32") / 255.0
    img = np.expand_dims(img, axis=0)
    return img

model = tf.keras.models.load_model(
    "/content/drive/MyDrive/Grad_School/SEIS_766 Vision AI/final_project/models/melanoma_cnn_arch1_35epochs.keras"
)

image_path = "example.jpg"
image_tensor = preprocess_image(image_path)

prediction = model.predict(image_tensor, verbose=0)[0][0]
predicted_label = "Malignant" if prediction >= THRESHOLD else "Benign"

print(f"Malignant probability: {prediction:.4f}")
print(f"Predicted label: {predicted_label}")
```

## Output Interpretation

- output close to `1.0` means the model predicts the image is more likely malignant
- output close to `0.0` means the model predicts the image is more likely benign
- this workflow used a classification threshold of `0.5`

## Notes

- Anyone loading the model will need TensorFlow installed.
- If the saved model file is shared outside Google Drive, update the `load_model(...)` path accordingly.
- If you later change the final architecture, image size, or threshold, update this README to match.

## Saved Model

In case the model needs to be updated and saved

The CNN can be saved in Keras format:

```python
from pathlib import Path

model_dir = Path("/content/drive/MyDrive/...")
model_dir.mkdir(parents=True, exist_ok=True)

model_path = model_dir / "melanoma_cnn_arch1_35epochs.keras"
model.save(model_path)
```

This creates a `.keras` model file that another user can load in their own notebook.
