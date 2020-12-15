from training.dataset_loader import DatasetLoader
from training.dataset_serializer import DatasetSerializer
import training.model.model_trainer as model_trainer
import numpy as np
from training.model.model_serializer import ModelSerializer
import matplotlib.pyplot as plt


def load_deserialized_dataset():
    loader = DatasetLoader()
    serializer = DatasetSerializer()

    fake_set, real_set = loader.load_images("monet")
    serializer.serialize(fake_set, real_set, "monet")

    return fake_set, real_set


def load_serialized_dataset():
    serializer = DatasetSerializer()
    fake_set, real_set = serializer.deserialize("monet")

    return fake_set, real_set


if __name__ == '__main__':
    #fake_set, real_set = load_deserialized_dataset()
    fake_set, real_set = load_serialized_dataset()

    # model_serializer = ModelSerializer()
    # model = model_serializer.deserialize("monet")
    # generated_image = ((model.predict(real_set[:1]) + 1) * 127.5).astype('int')
    #
    # images = [real_set[0], generated_image[0]]
    #
    # fig = plt.figure(figsize=(8, 8))
    # columns = 2
    # rows = 1
    # for i in range(1, columns * rows + 1):
    #     img = images[i-1]
    #     fig.add_subplot(rows, columns, i)
    #     plt.imshow(img)
    # plt.show()

    model_trainer.create_model_and_train(real_set, fake_set, (256, 256, 3), "monet")
