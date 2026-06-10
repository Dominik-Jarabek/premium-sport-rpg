from PIL import Image
import numpy as np

img = Image.open("logo.png").convert("RGBA")
data = np.array(img)

r, g, b, a = data[:,:,0], data[:,:,1], data[:,:,2], data[:,:,3]
mask = (r > 220) & (g > 220) & (b > 220)
data[mask] = [0, 0, 0, 0]

Image.fromarray(data).save("logo.png")
print("Hotovo!")