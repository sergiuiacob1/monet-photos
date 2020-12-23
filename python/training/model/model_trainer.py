import training.model.model_creator as model_creator
import numpy as np
import random
from training.model.model_serializer import ModelSerializer
import time
import math

MODEL_SERIALIZE_FREQUENCY = 5
CONTROL_IMAGE_FREQUENCY = 1

def load_model_and_train(real_dataset, fake_dataset, dataset_name, models):
    d_model_A = models['d_model_A']
    d_model_B = models['d_model_B']
    g_model_AtoB = models['g_model_AtoB']
    g_model_BtoA = models['g_model_BtoA']
    c_model_AtoB = models['c_model_AtoB']
    c_model_BtoA = models['c_model_BtoA']

    models, key = train(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, (real_dataset, fake_dataset), dataset_name)

    serializer = ModelSerializer()
    serializer.serialize(models, dataset_name, key)


def create_model_and_train(real_dataset, fake_dataset, image_shape, dataset_name):
    d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA = model_creator.create_model(
        image_shape)
    models, key = train(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, (real_dataset, fake_dataset), dataset_name)

    serializer = ModelSerializer()
    serializer.serialize(models, dataset_name, key)


def generate_real_samples(dataset, n_samples, patch_shape):
    # choose random instances
    ix = np.random.randint(0, dataset.shape[0], n_samples)
    # retrieve selected images
    X = dataset[ix]
    # generate 'real' class labels (1)
    y = np.ones((n_samples, patch_shape, patch_shape, 1))
    return X, y


def generate_fake_samples(g_model, dataset, patch_shape):
    # generate fake instance
    X = g_model.predict(dataset)
    # create 'fake' class labels (0)
    y = np.zeros((len(X), patch_shape, patch_shape, 1))
    return X, y


def update_image_pool(pool, images, max_size=50):
    selected = list()
    for image in images:
        if len(pool) < max_size:
            # stock the pool
            pool.append(image)
            selected.append(image)
        elif random.random() < 0.5:
            # use image, but don't add it to the pool
            selected.append(image)
        else:
            # replace an existing image and use replaced image
            ix = np.random.randint(0, len(pool))
            selected.append(pool[ix])
            pool[ix] = image
    return np.asarray(selected)


def pack_models(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, step_count):
    current_timestamp = math.floor(time.time())
    key = f'{current_timestamp}_{step_count}'
    models = dict()
    models['d_model_A'] = d_model_A
    models['d_model_B'] = d_model_B
    models['g_model_AtoB'] = g_model_AtoB
    models['g_model_BtoA'] = g_model_BtoA
    models['c_model_AtoB'] = c_model_AtoB
    models['c_model_BtoA'] = c_model_BtoA
    return models, key


def train(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, dataset, dataset_name):
    model_serializer = ModelSerializer()
    # define properties of the training run
    n_epochs, n_batch, = 100, 1
    # determine the output square shape of the discriminator
    n_patch = d_model_A.output_shape[1]
    # unpack dataset
    trainA, trainB = dataset
    # prepare image pool for fakes
    poolA, poolB = list(), list()
    # calculate the number of batches per training epoch
    bat_per_epo = int(len(trainA) / n_batch)
    # calculate the number of training iterations
    n_steps = bat_per_epo * n_epochs
    steps = 50
    # manually enumerate epochs
    for i in range(steps):
        # select a batch of real samples
        X_realA, y_realA = generate_real_samples(trainA, n_batch, n_patch)
        X_realB, y_realB = generate_real_samples(trainB, n_batch, n_patch)
        # generate a batch of fake samples
        X_fakeA, y_fakeA = generate_fake_samples(g_model_BtoA, X_realB, n_patch)
        X_fakeB, y_fakeB = generate_fake_samples(g_model_AtoB, X_realA, n_patch)
        # update fakes from pool
        X_fakeA = update_image_pool(poolA, X_fakeA)
        X_fakeB = update_image_pool(poolB, X_fakeB)
        # update generator B->A via adversarial and cycle loss
        g_loss2, _, _, _, _ = c_model_BtoA.train_on_batch([X_realB, X_realA], [y_realA, X_realA, X_realB, X_realA])
        # update discriminator for A -> [real/fake]
        dA_loss1 = d_model_A.train_on_batch(X_realA, y_realA)
        dA_loss2 = d_model_A.train_on_batch(X_fakeA, y_fakeA)
        # update generator A->B via adversarial and cycle loss
        g_loss1, _, _, _, _ = c_model_AtoB.train_on_batch([X_realA, X_realB], [y_realB, X_realB, X_realA, X_realB])
        # update discriminator for B -> [real/fake]
        dB_loss1 = d_model_B.train_on_batch(X_realB, y_realB)
        dB_loss2 = d_model_B.train_on_batch(X_fakeB, y_fakeB)
        # summarize performance
        print('>%d, dA[%.3f,%.3f] dB[%.3f,%.3f] g[%.3f,%.3f]' %
              (i + 1, dA_loss1, dA_loss2, dB_loss1, dB_loss2, g_loss1, g_loss2))

        if (i+1) % MODEL_SERIALIZE_FREQUENCY == 0:
            models, key = pack_models(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, i + 1)
            model_serializer.serialize(models, dataset_name, key, trainA[:3])

        if (i+1) % CONTROL_IMAGE_FREQUENCY == 0:
            model_serializer.serialize_control_images(g_model_AtoB, g_model_BtoA, trainA[:3], dataset_name, i+1)

    return pack_models(d_model_A, d_model_B, g_model_AtoB, g_model_BtoA, c_model_AtoB, c_model_BtoA, steps)
