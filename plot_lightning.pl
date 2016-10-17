#!/usr/bin/perl
# plot_lightning.pl
#
# sudo apt-get install libchart-perl
# 01/2013

use Chart::Points;
#use Chart::Lines;
use Net::FTP;

$DEBUG = 0;
$TEST = 0;

$PATH = "/var/www/html";

my $chart = new Chart::Points(300, 300);
#my $chart = new Chart::Lines(300, 300);

# FIND CURRENT TIME IN UNIX SECONDS - (3600 * 4) four hours
$curtime = time;
$maxhrs = ($curtime - (3600 *6 ));
if ($TEST) { $maxhrs = ($curtime - (3600 *9999 )); }

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

 my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
#$year = sprintf("%02d", $year % 100);
$year += 1900;

$time_str = "$abbr[$mon] $mday,$year";

my %property;
$property{'title' } = "Lightning Strikes - $time_str";
$property{'x_label'} = 'Time (Min)';
$property{'y_label'} = 'Distance (KM)';
$property{'legend'} = 'none';
$property{'min_val'} = 0;
$property{'max_val'} = 40;
$property{'include_zero'} = 'true';
$property{'integer_ticks_only'} = 'true';
$property{'skip_int_ticks'} = 10;
$property{'pt_size'} = 10;
$property{'sort'} = 'false';
$property{'xy_plot'} = 'false';
$property{'precision'} = '0';

$chart->set(%property);

# OPEN LIGHTNING DATA FILE $PATH/lightning.txt
$DATAFILE = "$PATH/lightning.txt";
if ($TEST) { $DATAFILE = "$PATH/lightningSAMPLE.txt"; }

open (MYFILE, $DATAFILE);
open (OUTFILE, ">$PATH/lightning_log.txt");

# FORMAT TIME UNIX SECONDS|DISTANCE
# UNIXSEC|KM

$strikecnt = 0;

# LOOP FOR EACH ENTRY
 while ($line = <MYFILE>) {
	# GET RID OF CR LF
 	$line =~ s/\r//g,$line;
	chomp ($line);

	if ($DEBUG) { print "LINE: [$line]\n"; }

	# SPLIT INTO TIME AND DISTANCE
	($logtime, $msg) = split /\|/,$line;

	if ($DEBUG) { print "LOGTIME: [$logtime] MSG: [$msg]\n"; }

	# LOG FILE
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isd) = localtime($logtime);
	$datetime = (1900+$year)."-".(1+$mon)."-".$mday." ".$hour.":".$min;

	print OUTFILE "$datetime|$msg\n";

	# READ LAST 4 HOURS WORTH OF DATA
	if ($logtime > $maxhrs) 
	{
	    # IS IT LIGHTNING?
	    if ($msg =~ "LIGHTNING")
	    {
		# SPLIT MESSAGE
		my ($text, $km) = split/\=/,$msg;
		
		# CONVERT TIME TO MINUTES  (Current time - entry time) /60 
		$minutes = int(($curtime - $logtime) /60);

	    	if ($DEBUG) { print "MINUTES: [$minutes] [$text] [$km]km\n"; }
		
		# ADD X-AXIS TIME TO ARRAY
		push (@time_array, "$minutes");

		# ADD Y-AXIS DISTANCE
		push (@dist_array, "$km");

		# COUNT
		$strikecnt++;
	    }
	}
 }

close (MYFILE);
close (OUTFILE);

# TEST
# ADD X-AXIS TIME TO ARRAY
#@time_array = (20,18,15,10,9,8,8,6,4,2,2,2);

# ADD Y-AXIS DISTANCE
#@dist_array = (22,18,20,15,5,13,6,14,12,26,43,35); 

# ADD STRIKE COUNT
$chart->set ('sub_title' => "Total Strikes: ".$strikecnt );
# ADD TO PLOT
# X-AXIS TIME 
$chart->add_dataset(@time_array);
# Y-AXIS DISTANCE
$chart->add_dataset(@dist_array);

$chart->png("$PATH/lightning.png");


# FTP TO WEBSITE
my $host = "www.grokett.org";
my $user = "grokett2";
my $password = "oehkBdTU";

my $f = Net::FTP->new($host) or die "Can't open $host\n";
$f->login($user, $password) or die "Can't log $user in\n";

my $dir = "public_html";
$f->cwd($dir) or die "Can't cwd to $dir\n";

$f->binary();
my $file_to_put = "$PATH/lightning.png";
$f->put($file_to_put) or die "Can't put $file into $dir\n";

$f->quit();

