#!/usr/bin/env perl

use v5.10.1;
use utf8;
use strict;
use warnings;
use autodie;
no warnings 'uninitialized';

use Email::Simple;
use List::Util qw(max);
use Data::Dumper;

my $dir = '../job_postings';
die "$dir does not exist." unless (-d $dir);

say "Getting the list of files...";

my @files = glob( "$dir/*.txt" );

my %companies;
my $exceptions = '../exceptions.txt';
my $companycsv = '../generated_company_list.csv';
my $companymd = '../generated_company_list.md';

open(my $EXCEPTIONS, ">", $exceptions);

say "Building the hash. There are thousands of files to parse, so this is going to take a while...";

foreach my $file ( @files ) {
	my $text = do { local( @ARGV, $/ ) = $file; <> };
	my $email = Email::Simple->new( $text );

	next unless $email->header( 'From' ) eq 'jobs-admin@perl.org (Perl Jobs)';

	my $body = $email->body;
	
	my ( $year )      = $body =~ /^Posted: \s+ [a-z]+ \s+ \d+, \s+ (\d+)/mix;
	my ( $name )      = $body =~ /^Company name:\s+(.*)$/mi;
	my ( $location )  = $body =~ /^Location:\s+(.*)$/mi;
	
  # Take care of the (hopefully) edge cases
	unless ($name) {
		# If there's no $name, log it to a file to look at later.
		say $EXCEPTIONS "$file";
		next;
	}
	
	$location = "Undefined" unless defined($location);
	
  # Set the hash values
  $companies{$name}{location} = $location; 
  push(@{$companies{$name}{years}}, $year);
}

close $EXCEPTIONS;

say "Creating the output files...";

my $mdheader = qq[
Perl Companies
==============

This is a list of companies which use (or used) Perl. The list was initially built using posts to [jobs.perl.org](http://jobs.perl.org) but from there on out it will be maintained manually by the community.

Most of the table below is self-explanatory, save the 'Hiring Status' column. An explanation of those values:

* **Active**: Company has posted an open Perl position at some point since 2011.
* **Dormant**: Company last posted an open Perl position between 2008 and 2011. The assumption is that either the company merely has not had a Perl opening for a while, has switched away from Perl, or is no longer a going business concern.
* **Inactive**: Company has not posted an open Perl position since before 2008. The assumption is that the company has either switched away from Perl or is no longer a going business concern.

<table>
<tr>
<th>Company Name</th>
<th>Company Location</th>
<th>Most Recent Posting</th>
<th>Hiring Status</th>
</tr>
];

my $csvheader = qq[
\"Company Name,\"
\"Company Location,\"
\"Most Recent Posting,\"
\"Hiring Status\"
];

open(my $COMPANYCSV, ">", $companycsv);        # For portability.
open(my $COMPANYMD, ">", $companymd);          # For readability & easier reference.

say $COMPANYMD $mdheader;

say $COMPANYCSV $csvheader;

say "Populating the output files...";

foreach (sort(keys(%companies))) {
  my $name = $_;
  my $location = $companies{$name}{location};	
  my $years = $companies{$name}{years};
	my $maxyear = max(@$years);

  my $status = set_status($maxyear);

  say $COMPANYCSV output_line($name, $location, $maxyear, $status, 'csv');
  say $COMPANYMD output_line($name, $location, $maxyear, $status, 'md');
}

say $COMPANYMD "</table>";

close $COMPANYCSV;
close $COMPANYMD;

say "Done. The data are in $companycsv and $companymd. 
Exceptions (unparsed files) are in $exceptions.";

#===========

sub set_status {
	my $year = shift;
		
	if ($year ge 2011) { return 'Active'; }
	elsif ($year lt 2011 && $year le 2008) { return 'Dormant'; }
	else { return 'Inactive'; }
}

sub output_line {
	my ($name, $location, $year, $status, $type) = @_;
	
	if ($type eq 'csv') {
		return "\"", 
           $name, 
           "\", \"", 
           $location, 
           "\", \"", 
           $year,
           "\"";
	}
	elsif ($type eq 'md') {
		return "$name | $location | $year";
	} 
	else {
		return "$name\n\t$location\n\t$year";
	}
}

exit 1;
