#!/usr/bin/env perl 

use 5.10.0;

use strict;
use warnings;

use autodie;

use YAML qw/ LoadFile /;
use Text::CSV;

my $csv = Text::CSV->new({ 
    binary              => 1,  
    auto_diag => 1,
    allow_whitespace => 1,
    always_quote => 1,
    eol => "\n",
    });

# TODO: Use Unicode::Collate based sorting here
my @companies = sort { lc $a->{name} cmp lc $b->{name} }
                     @{ LoadFile( 'Perl_Companies.yaml' ) };

open my $fh, '>', 'generated_company_list.md';

print {$fh} $_ for <DATA>;

for( @companies ) {
    my @cells = 
        @{$_}{qw/ name location most_recent_posting /};

    s/\|/\\|/g for @cells;

    say $fh sprintf "%-20s | %-30s | %5s", @cells;
}


__DATA__

Perl Companies
==============

This is a list of companies which use (or used) Perl. The list was initially built using posts to [jobs.perl.org](http://jobs.perl.org) but from there on out it will be maintained manually by the community.

Most of the table below is self-explanatory, save the 'Hiring Status' column. An explanation of those values:

* **Active**: Company has posted an open Perl position at some point since 2011.
* **Dormant**: Company last posted an open Perl position between 2008 and 2011. The assumption is that either the company merely has not had a Perl opening for a while, has switched away from Perl, or is no longer a going business concern.
* **Inactive**: Company has not posted an open Perl position since before 2008. The assumption is that the company has either switched away from Perl or is no longer a going business concern.

Company Name | Company Location | Most Recent Posting | Hiring Status
:----------- | :--------------- | :------------------ | :------------
