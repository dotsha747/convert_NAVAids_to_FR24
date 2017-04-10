#! /usr/bin/perl

# reads X-Plane/Navigraph Waypoints.txt and Navaids.txt, outputs
# .WPT file for use with flightradar24's Radar mode.

# india to australia
my $minLon = "67";
my $maxLon = "145";
my $minLat = "-12";
my $maxLat = "28";

# navigraph version
my $inWPT = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/Waypoints.txt";
my $inNav = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/Navaids.txt";
my $outfile = "waypoints-frdr24.wpt";


# main program

open (OUTF, "> $outfile") || die "Unable to write to $outfile\n";


# NavAids Format
# CE,CALEDONIAN,205.000,0,0,110,3.29508,101.45192,0,WM,0
# VBA,BATU ARANG,114.700,1,1,195,3.32481,101.45692,359,WM,0
# code, name, freq, ?, ?, ?, lat, long, ?, ?, ?

open (INF, $inNav) || die "Unable to open $inNav\n";

while (my $line = <INF>) {

	$line =~ s///;
	chomp ($line);

	my @d = split (/,/, $line);

	my $code = $d[0];
	my $name = $d[1];
	my $type = $d[3];
	my $lat = $d[6];
	my $lon = $d[7];

	if ($lat > $minLat && $lat < $maxLat && $lon > $minLon && $lon < $maxLon) {
		print OUTF "$code,$name," . ($type == 0 ? '4' : '3') . ",1,$lat,$lon,0\n";
	};
}

close (INF);


# NavAids Format
# AGOSA,3.14472,101.21917,WM
# name,lat,lon,?

open (INF, $inWPT) || die "Unable to open $inWPT\n";

while (my $line = <INF>) {

	$line =~ s///;
	chomp ($line);

	my @d = split (/,/, $line);

	my $code = $d[0];
	my $lat = $d[1];
	my $lon = $d[2];

	if ($lat > $minLat && $lat < $maxLat && $lon > $minLon && $lon < $maxLon) {
		print OUTF "$code,$code,5,2,$lat,$lon,0\n";
	};
}

close (INF);


close (OUTF);

