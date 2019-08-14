# Linux GCC cross- and/or native- tool-chain for C and C++ (GCC 9.2.0)
Scripts to build a linux-toolchain for:
+ the latticeMicro32 (LM32 soft-core processor)
+ the Atmel Atmega Micro-controller series (AVR) e.g. for Arduino
+ the native GCC compiler collection

# Obtaining a ready to use cross or native tool chain in only 3 respectively 4 steps:

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

4) Invoke the shell-script for your desired tool-chain:<br/>
```./build-lm32-toolchain.sh``` for building a LM32 tool chain<br/>
```./build-avr-toolchain.sh``` for building a AVR tool chain<br/>
```./build-native-toolchain.sh``` for building a native tool chain<br/>
This will take about 45 minutes to more than two hours depending of your computer, internet connection and chosen tool chain.

After this three respectively four steps the new toolchain is ready to use.

Building a linux-toolchain for Linux-ARM devices is in develop yet.

# Requirements
+ Commandline downloader <b>"wget"</b>. (Type ```which wget``` to check whether it's installed.)
+ Tape archiver <b>"tar"</b>. (Type ```which tar``` to check whether it's installed.)
+ Native GCC toolchain, respectively naive C/C++ compiler. (Type ```which gcc``` to check whether it's installed.)

# NOTE
If you desire a other version of GCC or of its components, so you can change this in the file ```gcc_versions.conf```.
But in this case it could become to compatibility problems, so you have to spend time to try the best combination of versions.
<br/>Following link could help you finding the combination of correct versions: https://wiki.osdev.org/Building_GCC<br/>
If you have got trouble may be the following link could help you: https://wiki.osdev.org/GCC_Cross-Compiler<br/><br/>
If you'll rebuild a tool-chain, so you have to delete the concerning build directory:</br> ```_build-<toolchain name>-<GCC-version number>``` bevore.

If you have installed the tool chain not in the standard directory e.g. ```/usr/bin/```,
and when you test the new tool chain so just actualize the environment variable ```PATH```:<br/>
```export PATH=/path/to/my/toolchain/bin:$PATH```<br/>
If you'll test a native tool chain, so you also complete the environment variable ```LD_LIBRARY_PATH```<br/>
```lib64/path/to/my/toolchain/lib64:/path/to/my/toolchain/lib:$LD_LIBRARY_PATH```<br/>
before you run a application compiled by these tool chain.</br></br>

To reduce the likely of trouble building a cross tool chain I recommend to build a native tool chain at first</br>(with ```build-native-toolchain.sh```) and build your desired cross tool chain by these native tool chain. 

