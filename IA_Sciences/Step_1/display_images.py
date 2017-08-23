from CIFAR10 import CIFAR10
import torchvision
import matplotlib.pyplot as plt
import numpy as np


def imshow(img):
    img = img / 2 + 0.5
    npimg = img.numpy()
    plt.imshow(np.transpose(npimg, (1, 2, 0)))


if __name__ == '__main__':
    data = CIFAR10()

    # Récupération des données
    dataiter = iter(data.loadTrainSet(size=16))
    images, labels = dataiter.next()    

    # Affichage de la mosaïque
    plt.axis('off')
    imshow(torchvision.utils.make_grid(images, nrow=4))
    for row in range(4):
        for col in range(4):
            plt.text(2 + 34 * col, 8 + 34 * row, CIFAR10.classes[labels[row * 4 + col]], fontsize=15, color='yellow')
    plt.show()
