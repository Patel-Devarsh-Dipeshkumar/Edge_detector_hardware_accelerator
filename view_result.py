import cv2
import numpy as np
import math
import os

input_path = r"C:\Users\Devarsh\OneDrive\Documents\Desktop\Img_accelaratir\output.hex"
output_image_name = "edge_detected_result.jpg"

def main():
    if not os.path.exists(input_path):
        print(f"ERROR: Could not find file at: {input_path}")
        print("Check if the Verilog simulation finished and saved the file.")
        return

    print(f"Reading hex data from: {input_path}")

    try:
        with open(input_path, 'r') as f:
            hex_lines = [line.strip() for line in f.readlines() if line.strip()]
    except Exception as e:
        print(f"Error reading file: {e}")
        return

    pixel_data = []
    for line in hex_lines:
        try:    
            val = int(line, 16)
            pixel_data.append(val)
        except ValueError:
            print(f"Warning: Skipping invalid line: {line}")

    total_pixels = len(pixel_data)
    print(f"Total pixels read: {total_pixels}")

    if total_pixels == 0:
        print("Error: The output file is empty! First Run simulation in Vivado")
        return

    dimension = int(math.sqrt(total_pixels))
    
    if dimension * dimension != total_pixels:
        print(f"Warning: Data size ({total_pixels}) is not a perfect square.")
        print(f"Attempting to reshape to {dimension}x{dimension}...")
        pixel_data = pixel_data[:dimension*dimension]

    print(f"Reshaping to image size: {dimension}x{dimension}")

    img_array = np.array(pixel_data, dtype=np.uint8).reshape((dimension, dimension))

    cv2.imwrite(output_image_name, img_array)
    print(f"Success! Saved image as '{output_image_name}'")

    cv2.imshow('Verilog Edge Detection Result', img_array)
    
    print("Press any key in the image window to close it...")
    cv2.waitKey(0)
    cv2.destroyAllWindows()

main()