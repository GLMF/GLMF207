import torch
import torchvision
import torchvision.transforms as transforms


class CIFAR10:
    classes = ('Avion', 'Voiture', 'Oiseau', 'Chat',
           'Cerf', 'Chien', 'Crapaud', 'Cheval', 'Bateau', 'Camion')

    def __init__(self):
        self.transform = transforms.Compose(
                        [transforms.ToTensor(),
                         transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

        self.trainset = torchvision.datasets.CIFAR10(root='./data', train=True,
                                        download=True, transform=self.transform)
        self.testset = torchvision.datasets.CIFAR10(root='./data', train=False,
                                       download=True, transform=self.transform)

    def loadTrainSet(self, size=4):
        return torch.utils.data.DataLoader(self.trainset, batch_size=size,
                                          shuffle=True, num_workers=2)

    def loadTestSet(self, size=4):
        return torch.utils.data.DataLoader(self.testset, batch_size=size,
                                          shuffle=False, num_workers=2)
