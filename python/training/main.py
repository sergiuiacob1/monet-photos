from training.dataset_loader import DatasetLoader
from training.dataset_serializer import DatasetSerializer
import training.model.model_trainer as model_trainer
import numpy as np
from training.model.model_serializer import ModelSerializer
import matplotlib.pyplot as plt
from training.image_adapter import ImageAdapter


def load_deserialized_dataset():
    loader = DatasetLoader()
    serializer = DatasetSerializer()

    fake_set, real_set = loader.load_images("monet")
    serializer.serialize(fake_set, real_set, "monet")

    fake_set = np.asarray(fake_set)
    real_set = np.asarray(real_set)

    return fake_set, real_set


def load_serialized_dataset():
    serializer = DatasetSerializer()
    fake_set, real_set = serializer.deserialize("monet")

    fake_set = np.asarray(fake_set)
    real_set = np.asarray(real_set)

    return fake_set, real_set


def create_model_and_train():
    image_adapter = ImageAdapter()

    # fake_set, real_set = load_deserialized_dataset()
    fake_set, real_set = load_serialized_dataset()

    normalized_fake_dataset = image_adapter.to_network_input(fake_set)
    normalized_real_dataset = image_adapter.to_network_input(real_set)

    model_trainer.create_model_and_train(normalized_real_dataset, normalized_fake_dataset, (256, 256, 3), "monet")


def load_model_and_show():
    set_key = "model_3500"
    image_adapter = ImageAdapter()

    # fake_set, real_set = load_deserialized_dataset()
    fake_set, real_set = load_serialized_dataset()

    model_serializer = ModelSerializer()
    model = model_serializer.deserialize_specific_network("monet", set_key, 'g_model_AtoB')

    np.random.shuffle(real_set)
    selected_images = real_set[:3]
    normalized_images = image_adapter.to_network_input(selected_images)

    network_output = model.predict(normalized_images)
    generated_images = image_adapter.to_image(network_output)

    images = np.concatenate((selected_images, generated_images))

    fig = plt.figure(figsize=(8, 8))
    columns = 3
    rows = 2
    for i in range(1, columns * rows + 1):
        img = images[i - 1]
        fig.add_subplot(rows, columns, i)
        plt.imshow(img)
    plt.show()


if __name__ == '__main__':
    #create_model_and_train()
    load_model_and_show()
