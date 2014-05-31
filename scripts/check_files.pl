#!/usr/bin/env perl

use strict;
use warnings;
use 5.10.1;
use autodie;

use YAML qw/ LoadFile /;
use Text::CSV;
use Data::Dumper;

my $yamlfile = "../Perl_Companies.yaml";
my $csvfile = "../Perl_Companies.csv";
my $mdfile = "../PerlCompanies.md";

say "Loading $yamlfile entries";
my @yaml = sort { lc $a->{name} cmp lc $b->{name} }
                     @{ LoadFile( $yamlfile ) };
say "Loading $csvfile entries";
# TODO
my @csv = [];

say "Loading $mdfile entries";
# TODO
my @md = [];

say "Number of entries in each file type:";
say "\tYAML: ". scalar(@yaml);
say "\tCSV: " . scalar(@csv);
say "\tMarkdown: " . scalar(@md);

if ( (scalar(@yaml) != scalar(@csv)) ||
     (scalar(@yaml) != scalar(@md))  ||
     (scalar(@csv) != scalar(@md))
   )
{
  say "The files do not match. Starting a search for errant entries.";
  compare_yaml_to_csv();
  compare_yaml_to_md();
  compare_csv_to_md();
} else {
  say "The files contain the same number of entries.";
}

# TODO
sub compare_yaml_to_csv {
  say "yamltocsv";
  #say Dumper($yaml[0]);
}

# TODO
sub compare_yaml_to_md {
  say "yamltomd";
}

# TODO
sub compare_csv_to_md {
  say "csvtomd";
}

say "Done checking.";

exit 1;
