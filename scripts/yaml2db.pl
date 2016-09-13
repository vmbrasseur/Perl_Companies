#!/usr/bin/env perl
use 5.10.1;
use warnings;
use lib qw(lib);

use PerlCompanies::DB;
use YAML qw(LoadFile);

my $db_file = $ENV{PERL_COMPANIES_DB} // 'Perl_Companies.db';
my $schema = PerlCompanies::DB->connect( "dbi:SQLite:dbname=$db_file", '', '',
    { sqlite_unicode => 1 } );

$schema->deploy unless -e $db_file;    # deploy the database if the file is new

my $yaml_file = 'Perl_Companies.yaml';
my $companies = LoadFile($yaml_file);

for my $co (@$companies) {

    state $company_rs = $schema->resultset('Company');
    state $location_rs = $schema->resultset('Location');

    my $company = $company_rs->find_or_create(
        {
            name   => $co->{name},
            source => $yaml_file,
        }
    );

    my $location_row = $location_rs->find_or_create(
        {
            name   => $co->{location},
            source => $yaml_file,
        }
    );
    unless ( $location_row->companies->find( $company->id ) ) {
        $location_row->add_to_companies( { id => $company->id } );
    }
}
