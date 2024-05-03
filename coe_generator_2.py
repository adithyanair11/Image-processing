
import cv2
gray = cv2.imread("gray.bmp")
img = cv2.imread("flower.jpg")

coe = open("image.coe", "w")

coe.write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")


col = 'gray'
st = ""


for i in range(gray.shape[0]):
    for j in range(gray.shape[1]):
        bi = ""
        string = "bi = bin(" + col + "[i][j][0])[2:]"
        exec(string)
        for l in range(8-len(bi)):
            bi = '0' + bi
        st = st + bi
        coe.write(st)
        x = ""
        for l in img[i][j]:
            bil = bin(l)[2:]
            for m in range(8-len(bil)):
                bil = '0' + bil
            x = x + bil
        coe.write(x + ',\n')
        st = ""

coe.close()
