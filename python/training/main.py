from training.dataset_loader import DatasetLoader
from training.dataset_serializer import DatasetSerializer


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

    print(len(fake_set))
    print(len(real_set))
    print(real_set[0].shape)

