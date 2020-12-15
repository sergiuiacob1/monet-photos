import pickle
import os


class DatasetSerializer:
    # it is faster to load serialized images at the cost of disk usage.
    # a serialized data set occupies 10 times more disk space that a deserialized one.
    # it is much slower to load from disk a deserialized dataset.

    base_path = os.getcwd()
    serialised_folder_name = "serialized"

    def serialize(self, fake_set, real_set, set_name):
        path = os.path.join(self.base_path, "dataset", set_name, self.serialised_folder_name)
        fake_path = os.path.join(path, "fake.bin")
        real_path = os.path.join(path, "real.bin")

        self.serialize_set(fake_set, fake_path)
        self.serialize_set(real_set, real_path)

    def deserialize(self, set_name):
        path = os.path.join(self.base_path, "dataset", set_name, self.serialised_folder_name)
        fake_path = os.path.join(path, "fake.bin")
        real_path = os.path.join(path, "real.bin")

        fake_set = self.deserialize_set(fake_path)
        real_set = self.deserialize_set(real_path)

        return fake_set, real_set

    @staticmethod
    def serialize_set(image_set, path):
        file = open(path, "wb")
        pickle.dump(image_set, file)
        file.close()

    @staticmethod
    def deserialize_set(path):
        file = open(path, "rb")
        image_set = pickle.load(file)
        file.close()
        return image_set
