REM This is an example and won't work out of the box. You must change your paths accordingly.
@echo off
for /l %%x in (1, 1, 100) do (
	avrdude -Cavrdude.conf -v -patmega328p -cusbasp -e -Ulock:w:0x3F:m -Uefuse:w:0x04:m -Uhfuse:w:0xDE:m -Ulfuse:w:0xFF:m -B100
	avrdude -Cavrdude.conf -v -patmega328p -cusbasp -e -Ulock:w:0x0F:m -Uflash:w:optiboot-3devo_atmega328.hex:i
	echo =======================
	echo ^|^|      Loop %%x       ^|^|
	echo =======================
	echo.
	pause
)
