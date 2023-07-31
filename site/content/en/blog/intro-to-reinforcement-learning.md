---
title: "Introduction to Reinforcement Learning"
date: 2023-07-05T20:00:00Z
draft: false
tags: ["AI", "Deep Learning", "Reinforcement Learning"]
thumbnail: "https://j-santana-dev.github.io/itguynextdoor.github.io/andrea-de-santis-zwd435-ewb4-unsplash.jpg"
description: "TBD"
---

Hi and welcome to my blog! In this post I want to talk about Reinforcement Learning (RL). This is a very interesting topic inside the field of Deep Learning and Artificial Intelligence.

This post will be a bit theoretical, but I will try to explain the concepts in a simple way. This is important to understand the basics if we want to build a simple RL model in the future.

If this is the first time you visit my blog, you might want to read my previous posts to get some context:
* [Introduction to Artificial Intelligence: origins, types and applications]({{< ref "/blog/welcome-to-the-ai-world" >}})
* [Introduction to Deep Learning and Artificial Neural Networks]({{< ref "/blog/intro-to-deep-learning" >}})
* [PyTorch \'Hello World\']({{< ref "/blog/pytorch-hello-world" >}})

Okay, let's get started!

## Introduction
Reinforcement Learning can be understood by imagining a child learning to walk. Just like the child, an RL agent (or bot) learns through trial and error. The child is the **agent**, and its current situation is the **state**. The **action** of standing up and walking is the **policy** the child follows. The **reward** for the child is the ability to walk, and the **environment** is represented by the floor on which the child practices. In this way, RL mimics the process of learning by taking actions, observing the outcomes, and adjusting its behavior to achieve the best results, just like a child learning to walk step by step.

## What is Reinforcement Learning (RL)?
Reinforcement Learning (RL) is a subset of Machine Learning where an agent learns through trial and error by interacting with its environment in a iterative way.

During this process, the agent receives rewards or penalties based on its actions. By experiencing several outcomes, the agent gradually learns to achieve specific goals in an uncertain and often complex environment. RL relies in its ability to learn without any external supervision or human intervention.

In RL, the agent's aim is to continuously gather knowledge from its "experiences" and make decisions that maximize the rewards it receives.

## Concepts
Taking into account the previous paragraphs, we can define some basic concepts of RL:

* **Agent**: this is the bot/robot that interacts with the environment and learns from it.
* **Environment**: this is the "world" where the agent lives. It can be a real or a simulated environment. You can think of it as the "game" where the agent plays.
* **State**: this is the current situation of the agent in the environment. For example, if the agent is playing a game, the state would be the current level, the current score, the current position, etc.
* **Action**: this is the action that the agent takes in a given state. For example, if the agent is playing a game, the action would be to move left, move right, jump, etc.
* **Reward**: this is the feedback that the agent receives from the environment. It can be positive or negative (penalty). For example, if the agent is playing a game, the reward would be the score it gets after taking an action.
* **Policy**: this is the strategy that the agent uses to determine the next action based on the current state. For example, if the agent is playing a game, the policy would be the algorithm that determines the next action based on the current state.

## Maths behind Reinforcement Learning
To be honest, It took some time for me to understand the maths behind RL. In the next sections I will try to explain some mathematical concepts that are important to understand how RL works.

### The Bellman Equation
My journey began with the Bellman Equation. The Bellman Equation is a fundamental concept in dynamic programming and RL.

It is a recursive formula that put together the basic concepts we discussed earlier. It is used to calculate the **value** of a state, representing the maximun expected long-term reward of the current state, taking into account the potencial future states. 

The equation is written as follows:

```latex
V(s) = max (R(s,a) + γ*V(s'))
```
Where:
* `V(s)` is the reward value of the current state `s`.
* `R(s,a)` immediate reward received when transitioning to state `s` by taking action `a`.
* `γ` is the discount factor (0 <= γ <= 1) that determines the importance of future rewards. A high value of `γ` means that future rewards are more important than immediate rewards.
* `V(s')` is the value of the next state `s'` (expected reward)

To help visualize the equation, we can imagine a game where our agent is trying to reach a goal, for example, complete a maze. The agent starts in the initial state `s` and takes an action `a` (move left, move right, etc). The agent receives a reward `R(s,a)` and transitions to the next state `s'`. The agent repeats this process until it reaches the goal. If an action does not lead to the goal, the agent receives a negative reward (penalty) and tries another action.

### Markov Decision Processes (MDP)
TBD

## What's next?
TBD

---

![Would you like to know more?](https://j-santana-dev.github.io/itguynextdoor.github.io/know-more.png)

* [Bellman Equation](https://en.wikipedia.org/wiki/Bellman_equation)