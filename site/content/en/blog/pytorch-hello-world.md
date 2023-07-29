---
title: "PyTorch 'Hello World'"
date: 2023-07-30T20:00:00Z
draft: false
tags: ["AI", "PyTorch", "Deep Learning"]
thumbnail: https://j-santana-dev.github.io/itguynextdoor.github.io/hitesh-choudhary-pMnw5BSZYsA-unsplash.jpg
description: "In this post we are going to use PyTorch to build a simple Artificial Neural Network (ANN) that can convert Celsius temperatures to Fahrenheit."
---

## Introduction
In this post we are going to use PyTorch to build a simple Artificial Neural Network (ANN) that can convert Celsius temperatures to Fahrenheit. Of course, in a real-world scenario, we would use a formula to perform this simple conversion. However, since the goal of this post is to learn how to build a simple ANN using PyTorch, we will use it to perform the conversion instead. Why? Because it's fun! :smiley:

Of course, if this is your first time in my blog, you might read my previous posts to get some context:
* [Introduction to Artificial Intelligence: origins, types and applications]({{< ref "/blog/welcome-to-the-ai-world" >}})
* [Introduction to Deep Learning and Artificial Neural Networks]({{< ref "/blog/intro-to-deep-learning" >}})

## What is PyTorch?
PyTorch is an open-source machine learning framework developed by Meta. It is based on the Torch library and it is widely used in the field of deep learning by many important companies such as: Meta, Amazon, Salesforce, Tesla, and many more. PyTorch is written in Python (have I mentioned that I love Python? :heart_eyes:) and it is available under the BSD license.

## Setting up the environment using virtualenv
First, we need some python libraries so we can start working with PyTorch. Because I don't like to mess up my system's python installation, I prefer to use a virtual environment. You can use the following command to create a virtual environment with all the required libraries for this example:

```bash
~$ virtualenv -p python3 venv \
    && source venv/bin/activate \
    && pip3 install torch
```

## Talk is easy, show me the code!
Now that we have our environment ready, let's see the entire code. This represents a simple ANN that can convert Celsius temperatures to Fahrenheit. The code is heavily commented so you can understand what is going on.


main.py
```python
import torch
from torch import nn

# We want to be able to train our model on a hardware accelerator 
# like the GPU or MPS, if available
device = (
    "cuda"
    if torch.cuda.is_available()
    else "mps"
    if torch.backends.mps.is_available()
    else "cpu"
)
print(f"Using {device} device")

# Define the neural network class
class CelsiusToFahrenheit(nn.Module):
    # Initialize the model
    def __init__(self):
        super().__init__()

        # Define the linear function
        self.linear = nn.Linear(in_features=1, out_features=1)

        # Define the loss function (Mean Squared Error)
        # which computes the mean squared error between the predicted
        # and target outputs.
        self.loss_fn = nn.MSELoss()

        # Define the optimizer (Stochastic Gradient Descent)
        # the torch.optim module contains the optimizer classes
        # SGD is Stochastic Gradient Descent
        self.optimizer = torch.optim.SGD(self.parameters(), lr=0.001)

    # Compute the forward pass
    def forward(self, x):
        return self.linear(x)

    # Train function to train the model
    def train_loop(self, x, y):
        for epoch in range(10000):

            # Compute the predictions and loss
            pred = self(x)
            loss = self.loss_fn(pred, y)
            
            # backpropagate the loss
            loss.backward()

            # adjust the parameters by the gradients collected 
            # in the backward pass
            self.optimizer.step()

            # reset the gradients of model parameters
            # gradients by default add up, to prevent double-counting
            # we explicitly zero them at each iteration
            self.optimizer.zero_grad()

            # Print the loss every 100 epochs
            if (epoch + 1) % 100 == 0:
                print(f"Epoch: {epoch+1}, Loss: {loss.item():.4f}")

if __name__ == "__main__":
    # Generate some training data
    # we will create tensors with random values and size 100x1
    celsius = torch.round(torch.randn(100, 1, device=device), decimals=2)
    fahrenheit = torch.round(9 * celsius / 5 + 32, decimals=2)

    # Create the neural network instance
    model = CelsiusToFahrenheit()
    print(f"model: {model}")  # print the model!

    # Train the model
    model.train_loop(celsius, fahrenheit)

    # Test the model with a new input
    test_input = torch.tensor(
        [[0.0], [30.0], [100.0], [232.8]], device=device)  # Celsius

    for t in test_input:
        pred = model(t) # perform the prediction

        # Print the result
        print(f"Celsius: {t.item():.2f}, Fahrenheit: {pred.item():.2f}")
```

## What's going on here?
Let's break down the code with the most important parts.

### GPU or CPU?
This code is used to check if we have a GPU or MPS available. If we do, we will use it to train our model. If not, we will use the CPU instead.

```python
device = (
    "cuda"
    if torch.cuda.is_available()
    else "mps"
    if torch.backends.mps.is_available()
    else "cpu"
)
```

### The neural network class
This is the class that defines our neural network. It is a simple ANN with one input (`in_features`) and one output (`out_features`).
The input is the Celsius temperature and the output is the Fahrenheit temperature.
Since there's a linear relationship between Celsius and Fahrenheit, we can use a simple linear function to perform the conversion (`nn.Linear()`).
We also define the loss function `loss_fn` (Mean Squared Error) and the optimizer `optimizer` (Stochastic Gradient Descent). The `lr` parameter is the learning rate. It is used to control how much we adjust the weights of our neural network with respect to the loss gradient. The lower the value, the slower we will learn, but if the value is too high, we might skip the optimal solution. I've found that a value of 0.001 works well for this example.

```python
class CelsiusToFahrenheit(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(in_features=1, out_features=1)
        self.loss_fn = nn.MSELoss()
        self.optimizer = torch.optim.SGD(self.parameters(), lr=0.001)

    def forward(self, x):  # forward pass function
        return self.linear(x)
```

The forward pass function is used to compute the output of the neural network. It defines how the input data flows through the layers of the model. Here we simply override the `forward()` function from the `nn.Module` parent class. The `x` parameter is the input of the neural network.

In order to train the model, we need to compute the loss function and backpropagate the loss. That is exactly what the `train_loop()` function does. It iterates over the training data and computes the loss function. Then it backpropagates the loss and adjusts the parameters by the gradients collected in the backward pass. In this example, we use 10000 epochs to train the model, but you can change it to any number you want for your own experiments. In my case, I've found that I need at least 4500 epochs to get a good result if I use a learning rate of 0.001. 

```python
def train_loop(self, x, y):
    for epoch in range(10000):
        pred = self(x)
        loss = self.loss_fn(pred, y)
        
        loss.backward()

        self.optimizer.step()

        self.optimizer.zero_grad()

        if (epoch + 1) % 100 == 0:
            print(f"Epoch: {epoch+1}, Loss: {loss.item():.4f}")
```

In the main section we generate some training data (tensors) and use them to train our model. We also create a new tensor with some test data to test our model.

## Running the code!
If you run the code, you will see the following output:

```bash
~$ python3 main.py 

# We are using the cpu device
# but if you have a GPU or MPS available
# it will use it instead :)
Using cpu device

# print the torch version (only for additional info)
Pytorch version:  2.0.1+cu117

# if we print the model, we can see the internal
# structure of our neural network class
model: CelsiusToFahrenheit(
  (linear): Linear(in_features=1, out_features=1, bias=True)
  (loss_fn): MSELoss()
)

# The loss is decreasing over time
# that means that our model is learning!
Epoch: 100, Loss: 679.6824
Epoch: 200, Loss: 455.5289
Epoch: 300, Loss: 305.3003
Epoch: 400, Loss: 204.6159
...
Epoch: 9900, Loss: 0.0000
Epoch: 10000, Loss: 0.0000

# Test the model with a new input
Celsius: 0.00, Fahrenheit: 32.00
Celsius: 30.00, Fahrenheit: 85.99
Celsius: 100.00, Fahrenheit: 211.98
Celsius: 232.80, Fahrenheit: 451.00
```

## Conclusion
In this post, I've shown you how to create a simple neural network using Pytorch. You can use this code, combined with the Pytorch documentation, to better understand how neural networks work.

You may notice that the predictions are not always 100% accurate. That's because we are using a very simple neural network with only one input and one output feature. Also, remember that these algorithms are based on stochastic processes, so the results may vary from one execution to another.

## What's next?
I hope you enjoyed this post! If you want to learn more about Pytorch, check out the "Would you like to know more?" section below. In future posts, I will show you how to create more complex neural networks using Pytorch. Stay tuned!

---

![Would you like to know more?](https://j-santana-dev.github.io/itguynextdoor.github.io/know-more.png)

* I strongly recommend you to read the [Pytorch](https://pytorch.org/) documentation

* In the following video, you can see how Tesla uses Pytorch to train their self-driving cars! {{< youtube oBklltKXtDE >}}