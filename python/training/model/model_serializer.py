from tensorflow import keras
import keras_contrib


class ModelSerializer:
    @staticmethod
    def serialize(model, dataset_name):
        # serializes the model and it's associated metadata into a file named file_name
        # these generated_models are going to be stored into the generated_models folder
        path = f"./training/generated_models/{dataset_name}/model.hdf5"
        model.save(path)

    @staticmethod
    def deserialize(dataset_name):
        path = f"./training/generated_models/{dataset_name}/model.hdf5"
        model = keras.models.load_model(path, custom_objects={'InstanceNormalization':keras_contrib.layers.InstanceNormalization})

        return model
