import cv2
import numpy as np

input_filename = 'test_image.jpg'
output_filename = 'image.hex'
width = 100
height = 100

print(f"Reading {input_filename}...")


img = cv2.imread(input_filename, cv2.IMREAD_GRAYSCALE)

if img is None:
    print("Error: Could not find image. Make sure 'test_image.jpg' is in the folder!")
    exit()

img = cv2.resize(img, (width, height))

print(f"Converting to {output_filename}")
with open(output_filename, 'w') as f:
   
    for row in range(height):
        for col in range(width):
            pixel_value = img[row, col]
            f.write(f"{pixel_value:02x}\n")

print(f"Success! {output_filename} created.")
print(f"Image dimensions: {width}x{height}")
print(f"Total pixels: {width * height}")