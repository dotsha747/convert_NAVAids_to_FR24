#! /usr/bin/perl

# parse X-Plane's ATS.txt which holds the world's airways.

# india to australia
my $minLon = "67";
my $maxLon = "145";
my $minLat = "-12";
my $maxLat = "28";

# global
$minLon = -180;
$maxLon = 180;
$minLat = -90;
$maxLat = 90;

# navigraph version
my $infile = "/raiddata/Steam/steamapps/common/X-Plane 10/Custom Data/navdata/ATS.txt";
my $outfile = "airways-frdr24.out";


# main program

open (INF, $infile) || die "Unable to open $infile\n";
open (OUTF, "> $outfile") || die "Unable to write to $outfile\n";

# -1 = expecting header, n = expecting count more lines.
my $l = -1; 
my $nowname;
my @nowpoints;

while (my $line = <INF>) {

	$line =~ s///;
	chomp ($line);

	if ($l == -1) {
		# line is a header
		my (@d) = split (/,/, $line);
		$nowname = $d[1];
		$l = $d[2];

		print "Got $nowname with $l points [$line]\n";

	} elsif ($l > 0) {

		$l--;
		my (@d) = split (/,/, $line);
		my $lat = $d[2];
		my $lon = $d[3];

		# only interested in points in our bounding box
		if($lat > $minLat && $lat < $maxLat && $lon > $minLon && $lon < $maxLon) {
			push (@nowpoints, "$lat+$lon");
		};


	} else {

		# blank line
		$l--;

		# only emit if at least 1 point is in our boundin box
		if (scalar (@nowpoints) > 0) {
			print OUTF "{ $nowname }\n" . join ("\n", @nowpoints) . "\n-1\n\n";
		};

		@nowpoints = ();

	}
}

close (INF);
close (OUTF);
