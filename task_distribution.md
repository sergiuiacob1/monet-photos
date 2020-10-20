# App modules:
1. mobile app
    1.1. creating input data
    1.2. refining the transformed image
2. image transformation module
    2.1. model training
    2.2. applying the model on the input
3. REST service

# Requirements per modules:
1. Research mobile app development (Flutter)
2. Research state-of-the-art methods (GANs)
3. Research deployment on Google App Cloud

# Risk assesement
1. Assigning fixed tasks per team member at the start of development: we might realize that a task requires a lot more time than another one. Solution: assign tasks per batches to keep flexibility within the development process. Using Trello for this.
2. Lack of communication: we will have to do integration work at the end. If the requirements are not well defined, we might work on different things. Solution: agile development. Keep all of the members updated on the status of the others.
3. Cloud platform limitations: it is possible that the platform used for communicating between the modules isn't satisfying our requirements. We will look into multiple options and choose the best one.
4. Subpar model: insufficient data might cause our model to not perform well. We will try to gather as many images as possible to get satisfying results.
5. Integration issues: we might not be able to integrate the different module we will work on. To address this, we will mainly focus on the image transformation module, which is the core of our product. We will develop this module as a separate application itself, capable of taking an input (a random image) and giving an output (the image with Monet's style on top), so we can at least have a partially functioning demo for our application.

# First batch of tasks
Lucian:
1. Research state-of-the-art methods (GANs)
2. Create infrastructure for training models (keep versioned models)

Adrian:
1. Research state-of-the-art methods (GANs)
2. Create infrastructure for REST Service (Google App Cloud / another platform)

Sergiu:
1. Research state-of-the-art methods (GANs)
2. Create infrastructure for the mobile app (Flutter)

# Next possible batch of tasks
Lucian:
1. Train initial model on images, performance measurement

Adrian:
1. Initial integration between the modules

Sergiu:
1. Infrastructure for capturing input & creating REST client
