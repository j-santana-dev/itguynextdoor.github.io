---
title: "Introduction to Reinforcement Learning"
date: 2023-08-05T20:00:00Z
draft: true
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
In order to understand what Reinforcement Learning is, we can imagine a child learning to walk. The child tries to stand up and walk, but it falls. It tries again and again until it can finally walk. The child is learning by trial and error. This is the same way RL works.

Talking in more technical terms, the child would be **the agent** (the bot), the action of standing up and walking would be **the policy**, the reward would be **the ability to walk** and the **environment** would be the floor.

These four concepts are the basis of RL.

## What is Reinforcement Learning?
Reinforcement Learning is a type of Machine Learning that allows an **agent** to learn by trial and error through interaction with an **environment** in an iterative way. 

The agent receives rewards and penalties for its actions. This way, it learns to achieve a goal in an uncertain, potentially complex environment. This process happens in a loop and the agent tries to maximize the reward it receives with no supervision or human intervention.

In RL, the agent learns from "experience" and tries to capture the best possible knowledge to make the best possible decision.

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