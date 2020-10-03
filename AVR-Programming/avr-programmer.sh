#!/usr/bin/env bash

# Created by: Hazar Karabay
# https://github.com/hazarkarabay/avr-tqfp-programmer
#
# Modified by Stig B. Sivertsen
# sbsivertsen@gmail.com
# https://github.com/datamann/GA-weather-station
# 03.10.2020
# @see The GNU Public License (GPL) Version 3

# This is used on atmega328p barebone without a bootloader,
# this to try to get it as with low power consumption as possible.
# Since this is without bootloader you need a programmer like usbasp or arduino as isp to use this code and to upload your own code.

# Fuses set:
# efuse: 0b11111111 (0xff)
# hfuse: 0xd7
# lfuse: 0xe2

# Click link to se what these mean.
# http://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p&LOW=E2&HIGH=D7&EXTENDED=FF&LOCKBIT=3F

# Fuse Calculator:
# https://www.engbedded.com/fusecalc/

# Supports to types of programmers USBASP and Arduino as ISP,
# just uncomment the one you need.

# Uncomment to use USBASP Programmer
#programmer="usbasp"
#port="usb"

# Uncomment to use Arduino as ISP
programmer="stk500v1"
port="/dev/cu.usbserial-1410" # On windows this will be your com port.
baud="-b 19200"

for ((i = 0 ; i < 100 ; i++)); do
  echo $i
  ./avrdude -C ./avrdudeMiniCore.conf -v -p atmega328p -c $programmer -P $port $baud -e -U lock:w:0x3f:m -U efuse:w:0b11111111:m -U hfuse:w:0xd7:m -U lfuse:w:0xe2:m -B100
  ./avrdude -C ./avrdude.conf -v -p atmega328p -c $programmer -P $port $baud -U flash:w:./empty.hex:i -U lock:w:0x0f:m -B100
  
  # Uncomment and add your own hex file tu upload your code in the same process.
  #./avrdude -C ./avrdude.conf -v -p atmega328p -c $programmer -P $port $baud -U flash:w:./ATMEGA328P_Blink.ino.hex:i
  echo =======================
  echo ^|^|      Loop $i       ^|^|
  echo =======================
  echo.
  read -p "Press any key to resume ..."
done

