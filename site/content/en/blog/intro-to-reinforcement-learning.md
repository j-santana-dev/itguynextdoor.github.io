---
title: "Introduction to Reinforcement Learning, a Theoretical Approach (Part I)"
date: 2023-08-12T11:00:00Z
draft: false
tags: ["AI", "Deep Learning", "Reinforcement Learning"]
thumbnail: "https://j-santana-dev.github.io/itguynextdoor.github.io/andrea-de-santis-zwd435-ewb4-unsplash.jpg"
description: "In this post I want to introduce several important concepts related to Reinforcement Learning (RL)."
---

Hello and welcome to my blog! In this post I want to introduce several important concepts related to Reinforcement Learning (RL).

Although this post might have a somewhat theoretical aspect, I'll do my best to explain the concepts in a simple way.

Of course, if this is the first time you visit my blog, you might want to read my previous posts on this series to get a better understanding of the topics I'll discuss in this post:
* [Introduction to Artificial Intelligence: origins, types and applications]({{< ref "/blog/welcome-to-the-ai-world" >}})
* [Introduction to Deep Learning and Artificial Neural Networks]({{< ref "/blog/intro-to-deep-learning" >}})
* [PyTorch \'Hello World\']({{< ref "/blog/pytorch-hello-world" >}})

So, let's get started!

## Introduction
Imagine a child taking its first steps - stumbling, falling, and getting back up, all with the aim of walking. This process of trial and error, of learning from each attempt, can help to explain the essence of Reinforcement Learning (RL).

Just like a child, an RL **agent** (or bot/robot) learns by trial and error. It takes **actions** in an **environment**, transitioning from one **state** to another. The agent receives **rewards** for its actions, and its target is to learn the best possible **policy** (strategy) to obtain the maximum reward.

## What is Reinforcement Learning (RL)?
Reinforcement Learning (RL) is a subset of Machine Learning where an **agent** learns by interacting with the **environment** in an iterative way. By experiencing several outcomes, the agent gradually "learns" to achieve specific goals in an uncertain environment. Since the agent learns from its own "experiences", it is not necessary human intervention during the process. So, the agent's aim is to continuously gather knowledge and make decisions that maximize the rewards it receives.

## Concepts
Taking into account the previous paragraphs, we can define some basic concepts of RL:

* **Agent**: this is the bot/robot that interacts with the environment and learns from it.
* **Environment**: this is the "world" where the agent lives. It can be a real or a simulated environment. You can think of it as the "game" where the agent plays.
* **State**: this is the current situation of the agent in the environment. In a game, the state could be the current level, the current score, the current position, etc.
* **Action**: this is the action that the agent takes in a given state. The action could be to move left, move right, jump, etc.
* **Reward**: this is the feedback that the agent receives from the environment after taking an action. It can be positive or negative. 
* **Policy**: this is the strategy that the agent uses to determine the next action based on the current state. In other words, the algorithm that determines the next action based on the current state.

## Maths behind Reinforcement Learning

### The Bellman Equation
Our journey starts with the Bellman equation (introduced by Richard Bellman in the 1950s). This is possibly the most fundamental equation in dynamic programming and RL.

The Bellman equation is a recursive formula that put together the basic concepts we discussed in the previous section. It is used to calculate the **value** of a state, representing the maximun expected reward of the current state, taking into account the potencial future states.

For simplicity, in this post I will explain the Bellman equation for a deterministic environment (this means that the next state is always the same for a given state and action). In a future post I will expand this explanation to a stochastic environment (this means that the next state is not always the same for a given state and action) that is much more realistic and interesting.

The Bellman equation for a deterministic environment is written as follows:

```latex
V(s) = max (R(s,a) + γ*V(s'))
```
Where:
* `V(s)` is the reward value of the current state `s` (expected reward).
* `R(s,a)` immediate reward received when transitioning to state `s` by taking action `a`.
* `γ` is the discount factor (0 <= γ <= 1) that determines the importance of future rewards. A high value of `γ` means that future rewards are more important than immediate rewards.
* `V(s')` is the value of the next state `s'` (expected reward)

To help visualize the equation, we can imagine a simple game where our agent is trying to reach a goal, for example, complete a maze. The agent starts in the initial state `s` and takes an action `a` (move left, move right, etc). The agent receives a reward `R(s,a)` and transitions to the next state `s'`. The agent repeats this process until it reaches the goal.

For simplicity, let's assume that the agent only can move left, right, up or down. In addition, we will find forbidden states (:fire:) and a goal state (:trophy:) in the maze. Our little hero must reach the goal without touching the fire using the best possible path.

The following image shows the maze:
```
 ____________________________________________
|        |        |        |        |        |
|   :trophy:   |        |        |        |   :fire:    |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
| :fire:     |    :fire:   |        |        |        |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|   :fire:   |        |        |    :fire:   |        |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|   :fire:   |        |        |        |    :robot:   |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
```

If you didn't realize, I've built this maze simple enough to be able to see the best path with the naked eye. Let's draw the best two possible paths that our agent can follow. These paths are equivalent in order to reach the goal.  

```
 ____________________________________________
|        |        |        |        |        |
|   :trophy:   |   <    |   <    |        |   :fire:    |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
| :fire:     |    :fire:   |    ^   |   <    |   <    |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|   :fire:   |        |    ^   |    :fire:   |    ^   |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|   :fire:   |        |    ^   |   <    |    :robot:   |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
```

Now, how can we achieved this result (that we know is the best) using the Bellman equation? Let's see it step by step.

First, in order to calculate the value of each state using the Bellman equation, we must start with the final state (:trophy:). From this point, we can calculate the value of the rest of the cells **following the inverse path**. In order to calculate the values of the cells, we will take into account the following considerations:
* The value of this final state will be `V=1` (the maximum reward) because the agent has reached the goal.
* Let's assume a discount factor `γ=0.9` (that means that future expected rewards are very important).
* We'll assign a reward of `R(s,a)=-0.5` to each allowed cell. This means that the agent will try to reach the goal as fast as possible as it doesn't have any incentives to stay in that state.
* In order to keep the agent away from the fire, we'll assign the lowest possible reward to the fire cells. These values will be so low that the agent will never choose these cells. For this reason, we will skip the fire cells in order to keep the explanation simple.
* As in the previous point, given that we already know the best paths, we will skip the cells that are not part of them.

So, for our deterministic scenario, the distribuition of rewards `R(s,a)` will be as follows:
```
 ____________________________________________
|        |        |        |        |        |
|   :trophy:   | R=-0.5 | R=-0.5 |        |        |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        | R=-0.5 | R=-0.5 | R=-0.5 |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        | R=-0.5 |        | R=-0.5 |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        | R=-0.5 | R=-0.5 |   :robot:   |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
```

If we apply the Bellman equation to each cell, we get the following values:
* Cell (1,2): `V = -0.5 + 0.9*1 = 0.4`
* Cell (1,3): `V = -0.5 + (0.9*0.4) = -0.14`
* Cell (2,3): `V = -0.5 + (0.9*(-0.14)) = -0.63`
* Cell (2,4): `V = -0.5 + (0.9*(-0.63)) = -1.07`
* Cell (2,5): `V = -0.5 + (0.9*(-1.07)) = -1.46`
* Cell (3,3): `V = -0.5 + (0.9*(-0.63)) = -1.07`
* Cell (3,5): `V = -0.5 + (0.9*(-1.46)) = -1.81`
* Cell (4,3): `V = -0.5 + (0.9*(-1.07)) = -1.46` 
* Cell (4,4): `V = -0.5 + (0.9*(-1.46)) = -1.81`

```
 ____________________________________________
|        |        |        |        |        |
|   V=1  |  V=0.4 | V=-0.14|        |        |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        | V=-0.63|V=-1.07 |V=-1.46 |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        | V=-1.07|        |V=-1.81 |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
|        |        |        |        |        |
|        |        |V=-1.46 |V=-1.81 |    :robot:  |
|        |        |        |        |        |
|______ _|____ ___|________|________|________|
```

We can see that the values of the cells are getting lower and lower as we move away from the goal. Since the agent will always choose the action that maximizes the value of the next state, it will choose the path that takes it to the goal.

Notice that to calculate the value of the next state, we have only used the value of the current state and not all the values of the previous states. This is something that I will explain in future blog posts when I talk about the Markov Property and Markov Decision Processes (MDP), but for now, we can summarize that the evolution of the agent in the environment depends only on the present state and not on the past history of states.

## Summary
In this post, I have tried to explain some of the theoretical concepts that could help you to understand the basics of Reinforcement Learning. I also have explained the Bellman equation and how it can be used to solve a deterministic scenario using a simple example.

## What's next?
In future posts, I will show you how to use the Bellman equation to solve scenarios where outcomes are uncertain, and the agent relies on probabilities to choose the next action. When I settle down the theoretical concepts, I will show you how to implement a simple Reinforcement Learning case using PyTorch :sunglasses:! Stay tuned!

---

![Would you like to know more?](https://j-santana-dev.github.io/itguynextdoor.github.io/know-more.png)

* [Bellman Equation: definition from Wikipedia](https://en.wikipedia.org/wiki/Bellman_equation)
* In the following video, you can see a pretty good explanation of the Bellman equation for deterministic scenarios {{< youtube 14BfO5lMiuk >}}