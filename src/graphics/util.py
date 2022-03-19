import struct
from PIL import Image

with Image.open('pixil-frame-0.png', 'r') as image:
    pixels = list(image.getdata())

with open('board.dat', 'wb') as file:
    for pixel in pixels:
        value = '0x00'
        for color in pixel[:3]:
            value += hex(color)[-2:]
        file.write(struct.pack('i', int(value, 16)))