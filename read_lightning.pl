#!/usr/bin/perl
# Sample Perl script to transmit number
# to Arduino then listen for the Arduino
# to echo it back

use Device::SerialPort::Arduino;

$| = 1;

$DEBUG = 1;

$FILE= "/var/www/html/lightning.txt";

# Set up the serial port
my $Arduino = Device::SerialPort::Arduino->new(
 port	 => '/dev/ttyACM1',
 baudrate=> 9600,
 parity  => 'none',
 databits=> 8
);

# Send something via Serial
#$Arduino->communicate('HI');

# GET CURRENT UNIX TIME
$unixsec = time;

# OPEN APPEND FILE /www/docs/lightning.txt
open (MYFILE, ">>$FILE");

# WRITE UNIXTIME|MSG
print MYFILE "$unixsec|STARTED\n";

if ($DEBUG) { print "$unixsec|STARTED\n"; }

# CLOSE FILE
close (MYFILE);

# Read from Arduino
while (1) {
  $rcv_data = $Arduino->receive(1);

  # GET CURRENT UNIX TIME
  $unixsec = time;

  # OPEN APPEND FILE /www/docs/lightning.txt
  open (MYFILE, ">>$FILE");

  # WRITE UNIXTIME|MSG
  print MYFILE "$unixsec|$rcv_data\n";

  if ($DEBUG) { print "$unixsec|$rcv_data\n"; }

  # CLOSE FILE
  close (MYFILE);

  }

