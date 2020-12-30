# LightningDetector
##Raspberry Pi, Arduino &amp; AS3935 Lightning Sensor


This project connects an AS3935 Lightning sensor to an Arduino which is 
then connected to a Raspberry Pi weather station.

Lightning pulses are detected by the Arduino/AS3935 and read serially 
by the Raspberry and logged to a file. The Raspberry periodically reads
the lightning file and generates a PNG graph plotting detected strikes 
by distance and time.

## UPDATE
2016-10-17 - Original version for Tautic AS3935 SPI board (no longer avail)
	(See lib/ and src/ dirs for these files)

2017-08-14 - New version to support Embedded Adventures AS3935 module
using I2C Interface between board and Arduino.


## Lightning Detector Hardware
https://www.embeddedadventures.com/as3935_lightning_sensor_module_mod-1016.html
http://www.playingwithfusion.com/productview.php?pdid=22
https://github.com/raivisr/AS3935-Arduino-Library  
http://www.designspark.com/blog/detecting-lightning-with-an-arduino  
Buzzer https://www.adafruit.com/product/160
 
## WIRING
* Circuit:
*    Arduino Uno Arduino Mega  -->  MOD-1016 AS3935 PINS
*         SDA         SDA      -->  SDA   (SDA is labeled on the bottom of the Arduino)
*         SCL         SCL      -->  SCL   (SCL is labeled on the bottom of the Arduino)
*         pin  2      pin 2    -->  IRQ
*         GND         ''       -->  GND
*         5V          ''       -->  VCC

*         pin 9       pin 9    -->  Buzzer
*         GND         GND      -->  Buzzer 

## INSTALL/BUILD
### On Raspi:
Install Apache2 if not already installed:  
sudo apt-get install apache2  
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+w /var/www
sudo adduser pi www-data
git clone https://github.com/rgrokett/LightningDetector.git  
cd LightningDetector  
Copy src/LightningDetector directory to your PC   

### On Windows/Mac PC:
Install AS3935-Arduino-Library-master.zip to Arduino IDE Libraries  
Edit LightningDetector2.ino 
Compile LightningDetector2.ino and upload to your Arduino using IDE  
  
### On Raspi:
NOTE: Raspi Serial Port /dev/ttyACM0 or ttyACM1 are possible so you will need
to find and update scripts. Default is /dev/ttyACM1  9600baud 8bit

sudo apt-get install libdevice-serialport-perl
sudo cpan install Device::SerialPort::Arduino  

# If you need to manually install the serial port driver:
cd Device-SerialPort-Arduino
        perl Makefile.PL
        make
        make test
        make install
# Continue
sudo apt-get install libchart-perl  
sudo apt-get install cu  
cu -l /dev/ttyACM1 -s 9600  
Should get Connected.   
To exit use tilde dot (~.)  
cd /home/pi/LightningDetector  
sudo cp lightning /etc/init.d/  
sudo systemctl enable lightning
sudo reboot
 
##Add this to root crontab:
# FIX USB PORT ARDUINO  
11 04 * * * /bin/chmod o+rw /dev/ttyACM1 >/dev/null 2>&1  
  
##Add this to pi crontab:
# GENERATE LIGHTNING PLOT  
0,15,30,45 * * * * /home/pi/LightningDetector/plot_lightning.pl >/dev/null 2>&1  


## PROGRAMS:
lightning		-- /etc/init.d start program  
plot_lightning.pl	-- Generates PNG lightning plot from lightning.txt  
plot_lightningTEST.pl	-- Generates a test PNG lightning plot  
read_lightning.pl	-- Reads serial & writes data to /var/www/html/lightning.txt  
start			-- Runs the read_lightning.pl  
nohup.out		-- Contains logging and debugging info from read_lightning.pl  
  

## Plot Chart program
http://cpansearch.perl.org/src/CHARTGRP/Chart-2.4.1/Documentation.pdf  
http://www.devshed.com/c/a/Perl/Basic-Charting-with-Perl/  
./plot_lightning.pl  
 
## Serial READ Program
nohup ./read_lightning.pl &

## Buzzer
To get an audible alert, connect buzzer. This will beep during startup and 
anytime a strike is detected.


