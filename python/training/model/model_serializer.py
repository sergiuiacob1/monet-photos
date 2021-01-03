from tensorflow import keras
from pathlib import Path
import numpy as np
from training.image_adapter import ImageAdapter
import cv2
from training.model.model_creator import define_composite_model


class ModelSerializer:
    model_names = ['d_model_A', "d_model_B", "g_model_AtoB", "g_model_BtoA"]
    base_path = './training/generated_models/'
    image_shape = (256, 256, 3)

    def serialize(self, models, dataset_name, key):
        # serializes the model and it's associated metadata into a file named file_name
        # these generated_models are going to be stored into the generated_models folder

        folder_path = self.construct_folder_path(dataset_name, key)
        Path(folder_path).mkdir(parents=True, exist_ok=True)

        for name in self.model_names:
            model = models[name]
            file_name = f'{name}.h5'
            path = folder_path + file_name
            model.save(path)

    def deserialize(self, dataset_name, key):
        models = dict()

        for name in self.model_names:
            path = f"{self.base_path}/{dataset_name}/{key}/{name}.h5"
            model = keras.models.load_model(path)
            models[name] = model

        models['c_model_AtoB'] = define_composite_model(
            models['g_model_AtoB'],
            models['d_model_B'],
            models['g_model_BtoA'],
            self.image_shape)

        models['c_model_BtoA'] = define_composite_model(
            models['g_model_BtoA'],
            models['d_model_A'],
            models['g_model_AtoB'],
            self.image_shape)

        return models

    def deserialize_specific_network(self, dataset_name, key, network_name):
        path = f"{self.base_path}/{dataset_name}/{key}/{network_name}.h5"
        model = keras.models.load_model(path)
        return model

    def serialize_control_images(self, generator_to_fake, generator_to_real, normalized_images, dataset_name, key):
        image_adapter = ImageAdapter()
        folder_path = self.construct_folder_path(dataset_name, key)
        folder_path = folder_path + "control_images/"
        Path(folder_path).mkdir(parents=True, exist_ok=True)

        normalized_fakes = generator_to_fake.predict(normalized_images)
        normalized_generated_reals = generator_to_real.predict(normalized_fakes)
        real_images = image_adapter.to_image(normalized_images)
        generated_images = image_adapter.to_image(normalized_fakes)
        real_generated_images = image_adapter.to_image(normalized_generated_reals)
        images = zip(real_images, generated_images, real_generated_images)

        index = 0

        for real, fake, generated_real in images:
            index = index + 1
            image = np.hstack((real, fake, generated_real))
            image_path = f'{folder_path}{index}.jpg'
            cv2.imwrite(image_path, image)

    def construct_folder_path(self, dataset_name, key):
        return f'{self.base_path}/{dataset_name}/{key}/'