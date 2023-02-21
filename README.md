# 🧠 Handwritten character recognition using Dense Associative Memory

> ☣ **Warning:** This project was created for educational purposes only. It may contain non-optimal or outdated solutions.

### 📝 About
**Dense Associative Memories** are an extension of the traditional Hopfield networks that overcome the linear growth constraint between the number of input characteristics and stored memories. This is accomplished by introducing more powerful non-linear functions that result in a memory storage capacity that increases at a greater-than-linear rate with the number of feature neurons. 

In this project, Dense Associative Memory was implemented using *MATLAB (R2021b)*. The classic Hopfield network, even with the use of a fairly efficient second Order Storkey Rule, unfortunately had unnecessary pixels after recognition, albeit with a certain threshold value in some cases, they could be removed.

**_Important to know_**: Hopfield networks converge to the 'remembered' state when some part of this state is given. Thus, such a network can supplement or fix the image (e.g. with noise), but cannot (in most cases) 'associate' a completely new image.

### 🔠 Screenshots
**Program interface (Command Window)**

<img src="/_readmeImg/menu.png?raw=true 'Menu'" width="300">

**Stabilization (after memorizing and selecting the image to recognize)**

<img src="/_readmeImg/processing.gif?raw=true 'Processing'" width="500">

**Final results**

<img src="/_readmeImg/results.png?raw=true 'Results'" width="700">
