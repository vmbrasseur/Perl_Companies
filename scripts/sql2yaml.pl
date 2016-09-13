#!/usr/bin/env perl

use 5.10.1;
use warnings;
use autodie;

use lib qw(lib);
use PerlCompanies::DB;
use YAML qw(DumpFile);

my $db_file = $ENV{PERL_COMPANIES_DB} // 'Perl_Companies.db';
my $schema = PerlCompanies::DB->connect( "dbi:SQLite:dbname=$db_file", '', '',
    { sqlite_unicode => 1 } );

my $rs = $schema->resultset('Company')->search({},{order_by => 'name'});;

while( $row = $rs->next ) {
    no warnings 'uninitialized';
    my %cells = map { $_ => '' . $row->$_ } qw/name location most_recent_posting/;

    s/\|/\\|/g for values %cells;
    push @companies, \%cells;
}

DumpFile('Perl_Companies.yaml', \@companies);

