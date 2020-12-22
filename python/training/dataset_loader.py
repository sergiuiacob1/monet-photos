from cv2 import cv2
import os


class DatasetLoader:
    base_path = os.path.join(os.getcwd(), "training")

    def load_images(self, set_name):
        fake_set_path = os.path.join(self.base_path, "dataset", set_name, "fake")
        real_set_path = os.path.join(self.base_path, "dataset", set_name, "real")

        fake_set = self.load_images_from_dir(fake_set_path)
        real_set = self.load_images_from_dir(real_set_path)

        return fake_set, real_set

    @staticmethod
    def load_images_from_dir(dir_name):
        image_set = []

        for (_, _, file_names) in os.walk(dir_name):
            for file_name in file_names:
                image_path = os.path.join(dir_name, file_name)
                image = cv2.imread(image_path, 1)
                image_set.append(image)

        return image_set


