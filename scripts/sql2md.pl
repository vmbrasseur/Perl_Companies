#!/usr/bin/env perl

use 5.10.1;
use warnings;
use autodie;

use lib qw(lib);
use PerlCompanies::DB;

my $db_file = $ENV{PERL_COMPANIES_DB} // 'Perl_Companies.db';
my $schema = PerlCompanies::DB->connect( "dbi:SQLite:dbname=$db_file", '', '',
    { sqlite_unicode => 1 } );

my $rs = $schema->resultset('Company')->search({},{order_by => 'name'});;

open my $fh, '>', 'Perl_Companies.md';
print {$fh} $_ for <DATA>;

while( $row = $rs->next ) {
    my @cells = map { $row->$_ } qw/ name location most_recent_posting hiring_status/;

    s/\|/\\|/g for @cells;

    say $fh sprintf "%-20s | %-30s | %5s | %s", @cells;
}


__DATA__

Perl Companies
==============

This is a list of companies which use (or used) Perl. The list was initially built using posts to [jobs.perl.org](http://jobs.perl.org) but from there on out it will be maintained manually by the community.

Most of the table below is self-explanatory, save the 'Hiring Status' column. An explanation of those values:

* **Active**: Company has posted an open Perl position at some point in the last 5 years.
* **Dormant**: Company last posted an open Perl position between 5 and 10 years ago. The assumption is that either the company merely has not had a Perl opening for a while, has switched away from Perl, or is no longer a going business concern.
* **Inactive**: Company has not posted an open Perl in 10+ years. The assumption is that the company has either switched away from Perl or is no longer a going business concern.

Company Name | Company Location | Most Recent Posting | Hiring Status
:----------- | :--------------- | :------------------ | :------------
