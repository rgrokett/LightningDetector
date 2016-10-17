# LightningDetector
Raspberry Pi, Arduino &amp; AS3935 Lightning Sensor

This project connects an AS3935 Lightning sensor to an Arduino which is 
then connected to a Raspberry Pi weather station.

Lightning pulses are detected by the Arduino/AS3935 and read serially 
by the Raspberry and logged to a file. The Raspberry periodically reads
the lightning file and generates a PNG graph plotting detected strikes 
by distance and time.


# Lightning Detector
http://wiki.tautic.com/Category:AS3935_Lightning_Sensor_Dev_Board
https://github.com/raivisr/AS3935-Arduino-Library
http://www.designspark.com/blog/detecting-lightning-with-an-arduino


# INSTALL/BUILD
# From Raspi:
Install Apache2 if not already installed:
sudo apt-get install apache2
git clone https://github.com/rgrokett/LightningDetector.git
cd LightningDetector
Copy src/LightningDetector directory to your PC 

# From Windows/Mac PC:
Install AS3935-Arduino-Library-master.zip to Arduino IDE Libraries
Compile LightningDetector.ino and upload to your Arduino using IDE

# From Raspi:
NOTE: Raspi Serial Port /dev/ttyACM0 or ttyACM1 are possible so you will need
to find and update scripts. Default is /dev/ttyACM1
sudo cpan install Device::SerialPort::Arduino
sudo apt-get install libchart-perl
sudo apt-get install cu
cu -l /dev/ttyACM1 -s 9600
Should get Connected. 
To exit use tilde dot (~.)
sudo cp lightning /etc/init.d/
sudo update-rc.d lightning enable 345

#Add this to root crontab:
# FIX USB PORT ARDUINO
11 04 * * * /bin/chmod o+rw /dev/ttyACM1 >/dev/null 2>&1

#Add this to pi crontab:
# GENERATE LIGHTNING PLOT
0,15,30,45 * * * * /home/pi/LightningDetector/plot_lightning.pl >/dev/null 2>&1


# PROGRAMS:
lightning		-- /etc/init.d start program
plot_lightning.pl	-- Generates PNG lightning plot from lightning.txt
plot_lightningTEST.pl	-- Generates a test PNG lightning plot
read_lightning.pl	-- Reads serial & writes data to /var/www/html/lightning.txt
start			-- Runs the read_lightning.pl
nohup.out		-- Contains logging and debugging info from read_lightning.pl


# Plot Chart program
http://cpansearch.perl.org/src/CHARTGRP/Chart-2.4.1/Documentation.pdf
http://www.devshed.com/c/a/Perl/Basic-Charting-with-Perl/
./plot_lightning.pl

# Serial READ Program
nohup ./read_lightning.pl &


