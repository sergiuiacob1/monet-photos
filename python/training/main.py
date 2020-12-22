from training.dataset_loader import DatasetLoader
from training.dataset_serializer import DatasetSerializer
import training.model.model_trainer as model_trainer
import numpy as np
from training.model.model_serializer import ModelSerializer
import matplotlib.pyplot as plt
import random
from training.image_adapter import ImageAdapter


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
    set_key = "1608650427_99"
    image_adapter = ImageAdapter()
    #fake_set, real_set = load_deserialized_dataset()
    fake_set, real_set = load_serialized_dataset()

    fake_set = np.asarray(fake_set)
    real_set = np.asarray(real_set)

    # model_serializer = ModelSerializer()
    # models = model_serializer.deserialize("monet", set_key)
    # model = models['g_model_AtoB']
    #
    # np.random.shuffle(real_set)
    # selected_image = real_set[0]
    # serialized_image = image_adapter.to_network_input(selected_image)
    #
    # network_output = model.predict(np.asarray([serialized_image]))
    # generated_image = image_adapter.to_image(network_output[0])
    #
    # print(generated_image)
    #
    # images = [selected_image, generated_image]
    #
    # fig = plt.figure(figsize=(8, 8))
    # columns = 2
    # rows = 1
    # for i in range(1, columns * rows + 1):
    #     img = images[i-1]
    #     fig.add_subplot(rows, columns, i)
    #     plt.imshow(img)
    # plt.show()

    normalized_fake_dataset = image_adapter.to_network_input(fake_set)
    normalized_real_dataset = image_adapter.to_network_input(real_set)

    model_trainer.create_model_and_train(normalized_real_dataset, normalized_fake_dataset, (256, 256, 3), "monet")
