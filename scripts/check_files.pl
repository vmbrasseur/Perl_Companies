#!/usr/bin/env perl

use strict;
use warnings;

use autodie;

use YAML qw/ LoadFile /;
use Text::CSV;

my $yamlfile = "../Perl_Companies.yaml";
my $csvfile = "../Perl_Companies.csv";
my $mdfile = "../PerlCompanies.md";

my $csvout = Text::CSV->new({
    binary              => 1,
    auto_diag => 1,
    allow_whitespace => 1,
    always_quote => 1,
    eol => "\n",
    });

my @yaml = sort { lc $a->{name} cmp lc $b->{name} }
                     @{ LoadFile( $yamlfile ) };

my @csv = [];

my @md = [];

print "Number of entries in each file type:\n";
print "YAML: ". scalar(@yaml) . "\n";
print "CSV: " . scalar(@csv) . "\n";
print "Markdown: " . scalar(@md) . "\n";

exit 1;
