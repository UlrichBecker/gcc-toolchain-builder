# Linux lm32-toolchain for C and C++
Script to build a linux-toolchain for the latticeMicro32 (LM32 soft-core processor)

# Obtaining a ready to use LM32-GCC toolchain in only 3 respectively 4 steps:

1) Cloning this repository.<br/>
```git clone https://github.com/UlrichBecker/gcc-toolchain-builder.github```

2) Change in the following directory:<br/>
```cd gcc-toolchain-builder```

3) By default the toolchain will installed in the hidden directory<br/>
```${HOME}/.local```<br/>
If you desire the toolchain in a other directory, so you have to initialize the shell variable PREFIX.<br/>
E.g.:<br/>
```export PREFIX=/path/to/my/toolchain```<br/>
Otherwise you can omit this step.

4) Invoke the shell-script:<br/>
```./build-lm32-toolchain.sh```<br/>
This will take about 45 minutes depending of your computer and internet connection.

After this three respectively four steps the new toolchain is ready to use.

Building a linux-toolchain for AVR Microcontrollers is in develop yet.
