class ModelSerializer:
    def serialize(self, file_name, model, metadata):
        # serializes the model and it's associated metadata into a file named file_name
        # these models are going to be stored into the models folder
        # metadata contains info about timestamp and neural network parameters such as bias, iteration count etc.
        pass

    def deserialize(self, file_name):
        # takes the file_name and returns a (model, metadata) tuple
        pass

