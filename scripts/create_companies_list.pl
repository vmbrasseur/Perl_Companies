#!/usr/bin/env perl

use v5.10.1;
use utf8;
use strict;
use warnings;
use autodie;
no warnings 'uninitialized';

use Email::Simple;
use List::Util qw(max);

my $debug = '1';

my $dir = '../job_postings';
die "$dir does not exist." unless (-d $dir);

say "Getting the list of files...";

my @files = glob( "$dir/*.txt" );
#my @files = ("$dir/3098.txt");

my %companies;
my $numfiles;
my $exceptions = 'exceptions.txt';
my $companycsv = 'Perl_Companies.csv';
my $companymd = 'Perl_Companies.md';

open(my $EXCEPTIONS, ">", $exceptions);

say "Building the hash...";

foreach my $file ( @files ) {
	#if ($debug) {say "\tWorking on $file";}
	$numfiles++;
	my $text = do { local( @ARGV, $/ ) = $file; <> };
	my $email = Email::Simple->new( $text );

	next unless $email->header( 'From' ) eq 'jobs-admin@perl.org (Perl Jobs)';

	my $body = $email->body;

	#my $posting = $body =~ m|^Online URL for this job: http://jobs\.perl\.org/job/(\d+)|m;
	
	my ( $year )      = $body =~ /^Posted: \s+ [a-z]+ \s+ \d+, \s+ (\d+)/mix;
	my ( $name )      = $body =~ /^Company name:\s+(.*)$/mi;
	my ( $location )  = $body =~ /^Location:\s+(.*)$/mi;
	
  # Take care of the (hopefully) edge cases
	unless ($name) {
		say $EXCEPTIONS "$file";
		next;
	}
	
	$location = "Undefined" unless defined($location);
	
  # Set the values
  $companies{$name}{location} = $location; 
  push(@{$companies{$name}{years}}, $year);
}

close $EXCEPTIONS;

say "Creating the output files...";

open(my $COMPANYCSV, ">", $companycsv);        # For number crunchers
open(my $COMPANYMD, ">", $companymd);          # More human readable. For easier reference.

say $COMPANYMD "
<table>
<tr>
<th>Company Name</th>
<th>Company Location</th>
<th>Most Recent Posting</th>
<th>Hiring Status</th>
</tr>
";

say $COMPANYCSV "
\"Company Name,\"
\"Company Location,\"
\"Most Recent Posting,\"
\"Hiring Status\"
";

say "Populating the output files...";

use Data::Dumper;

foreach (sort(keys(%companies))) {
  my $name = $_;
  my $location = $companies{$name}{location};	
  my @years = $companies{$name}{years};
#if ($debug) {say Dumper(@years);}
	my $maxyear = max(@years);
if ($debug) {say Dumper($maxyear);}

# XXX max() is returning an array. Why is max() returning an array? WTF?

	if (ref ($maxyear) eq 'ARRAY') {
		say "Whoa! maxyear is an array for $name, $location.";
		exit 1;
	}

  my $status = set_status($maxyear);

  say $COMPANYCSV output_line($name, $location, $maxyear, $status, 'csv');
  say $COMPANYMD output_line($name, $location, $maxyear, $status, 'md');
}

say $COMPANYMD "</table>";

close $COMPANYCSV;
close $COMPANYMD;

say "File count is $numfiles";

#===========

sub set_status {
	my $year = $_;
	
	if ($year ge 2011) { 
    return 'Active'; 
  }
	elsif ($year lt 2011 && $year le 2008) { 
    return 'Dormant'; 
  }
	else { 
    return 'Inactive'; 
  }
}

sub output_line {
	my ($name, $location, $status, $year, $type) = @_;
	
	if ($type eq 'csv') {
		return "\"", 
           $name, 
           "\", \"", 
           $location, 
           "\", \"", 
           $status, 
           "\"";
	}
	elsif ($type eq 'md') {
		return "<tr><td>$name</td><td>$location</td><td>$status</td></tr>";
	} 
	else {
		return "$name\n\t$location\n\t$status";
	}
}

exit 1;
