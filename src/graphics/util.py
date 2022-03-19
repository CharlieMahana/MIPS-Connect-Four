import struct
from PIL import Image

# convert board png to pixel array
with Image.open('board.png', 'r') as image:
    pixels = list(image.getdata())

with open('board.dat', 'wb') as file:
    for pixel in pixels:
        value = '0x00'
        for color in pixel[:3]:
            value += hex(color)[2:]
        file.write(struct.pack('i', int(value, 16)))

# convert token png to pixel array
with Image.open('token.png', 'r') as image:
    pixels = list(image.getdata())

with open('token.dat', 'wb') as file:
    for pixel in pixels:
        value = '0x00'
        for color in pixel[:3]:
            value += hex(color)[2:]
        print(int(value, 16))
        file.write(struct.pack('i', int(value, 16)))

# double check token.dat
with open('token.dat', 'rb') as file:
    data = file.read(4)
    print(data)