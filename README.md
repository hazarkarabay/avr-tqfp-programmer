Program TQFP AVR's easily without soldering
=====================

[![Moving image!](https://img.youtube.com/vi/9b8XTmfmTiI/0.jpg)](https://www.youtube.com/watch?v=9b8XTmfmTiI)

So, you designed a board that incorporates a SMD AVR and forgot to break out ISP pins. How you gonna upload your code/(if you have serial pins available)bootloader on your microcontroller?

This was my problem. Instead of adding test points to relevant signals, reordering PCBs and messing with pogo pins, I preprogrammed the chips using a TQFP adapter. Here's how I do it.

### You'll need:
- An AVR ISP programmer. You can use a dedicated programmer (Atmel MKII, Atmel ICE3, USBasp etc.) or you can use an Arduino as ISP. If you are not sure, read here: https://learn.sparkfun.com/tutorials/installing-an-arduino-bootloader
- A TQFP to DIP adapter. [I'm using this.](https://www.aliexpress.com/item/Free-shipping-Chip-programmer-TQFP32-QFP32-LQFP32-TO-DIP28-adapter-socket-support-ATMEGA8-series-TL866A-TL866CS/1969735009.html?aff_platform=ae-aff-deeplink&cpt=1499865009701&sk=UznmeyJee&aff_trace_key=a9dd8dea9e4f4ac5bc85a772afb82508-1499865009701-08514-UznmeyJee)
- ISP to TQFP-DIP adapter board. This board goes between your ISP programmer and TQFP adapter. You can get the adapter board from [pcbs.io](https://PCBs.io/share/r1D3D) or make the board with files provided in this repo and using your favorite method (toner transfer, photoresist etc.)

<a href="https://PCBs.io/share/r1D3D"><img src="https://s3.amazonaws.com/pcbs.io/share.png" alt="Order from PCBs.io"></img></a>

If you prefer using another PCB manufacturer, feel free to use provided Gerber files.
- AVRDUDE - http://www.nongnu.org/avrdude/

_If your programmer has a ZIF socket (like most Chinese programmers), you don't need that adapter board, you can directly put the TQFP-DIP adapter to your programmers' ZIF socket._    

### How to program your device:
The exact `avrdude` command varies with your programmer and chip type. `avrdude` is a fairly flexible and powerful utility, **please** don't blindly copy/paste the commands provided below, read the `avrdude` manual beforehand. **You can disable your chip with `avrdude` if you mess up fuses and don't know what are you doing.**

>*Word on __disabling__: You can effectively disable the ISP interface **while using** an ISP programmer. If you do this, you can't program your chip over ISP anymore, and it appears [dead](https://hydra-media.cursecdn.com/dota2.gamepedia.com/b/b6/Chatwheel_all_dead.wav). You'll need a real (i.e. high voltage) programmer for restoring at this point (in some situations avrdude can fix that, but do not rely on it). Please don't mess with debugWIRE and RESET fuses if you don't know it. More information can be found at http://www.avrfreaks.net/forum/tutsoft-recovering-locked-out-avr*

After you connect your ISP programmer and adapter, you are ready to program your chip with `avrdude`.
Here is the valid command for **ATMega328P and USBasp** programmer.
```
avrdude -v -patmega328p -cusbasp -e -Ulock:w:0x3F:m -Uefuse:w:0x04:m -Uhfuse:w:0xDE:m -Ulfuse:w:0xFF:m -B100
avrdude -v -patmega328p -cusbasp -e -Ulock:w:0x0F:m -Uflash:w:yoursoftware-withbootloader.hex:i
```

There is 2 seperate commands. First commands only sets the fuse bits and prepares ATMega328P for the actual programming. It sets the crystal, brownout level, disables any locks and does all of it slowly (-B100), because a factory-new ATMega328P comes with its 1MHz internal clock fuse set and USBasp, by default, tries pushing data faster than 250KHz. (ISP frequency is MCU clock/4.) 

Second command is actually programs your hex file and sets the lock fuse to prevent modifying bootloader in your application. It's important, because if you don't set this; you can overwrite/corrupt your bootloader in your application. If you don't use bootloader, you'll need to modify it by your needs.

>**Lock bits explanation:**
There are "fuse bit calculators" on Internet. Here is a example that explains what is going on within the first command. 
http://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p&LOW=FF&HIGH=DE&EXTENDED=04&LOCKBIT=3F

### Batch file
I have a batch file to speed up programming multiple AVR's in order. You can see it working on my video. It is very basic, only has a loop and a counter. It serves to my needs and you should customize it if your needs is different. Note that it can't work out of the box, at least the paths needs to be changed.
