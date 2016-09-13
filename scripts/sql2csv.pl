#!/usr/bin/env perl

use 5.10.1;
use warnings;
use autodie;


use lib qw(lib);
use Text::CSV;
use PerlCompanies::DB;

my $csv = Text::CSV->new({
    binary              => 1,
    auto_diag => 1,
    allow_whitespace => 1,
    always_quote => 1,
    eol => "\n",
    });

my $db_file = $ENV{PERL_COMPANIES_DB} // 'Perl_Companies.db';
my $schema = PerlCompanies::DB->connect( "dbi:SQLite:dbname=$db_file", '', '',
    { sqlite_unicode => 1 } );

my $rs = $schema->resultset('Company')->search({},{order_by => 'name'});



open my $fh, '>', 'Perl_Companies.csv';

$csv->print( $fh => [
    "Company Name",
    "Company Location",
    "Most Recent Posting"
]);

while( my $row = $rs->next) {
    $csv->print( $fh => [
        map { $row->$_ } qw/ name location most_recent_posting /
    ]);
}


