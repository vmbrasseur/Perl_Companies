#!/usr/bin/env perl

use v5.10.1;
use utf8;
use warnings;
use autodie;
no warnings 'uninitialized';
use FindBin qw($Bin);
use lib qw("$Bin/../lib");

use Email::Simple;
use List::Util qw(max);
use Data::Dumper;
use PerlCompanies::DB;
use Path::Tiny qw(path);
use DateTime::Format::Natural;
use DateTime::Format::SQLite;

my $dir = "$Bin/../job_postings";
die "$dir does not exist." unless ( -d $dir );

my $exceptions = "$Bin/../exceptions.txt";

open( my $EXCEPTIONS, ">", $exceptions );

say "Building the db. This is going to take a while...";

my $db_file = $ENV{'PERL_COMPANIES_DB'} // 'Perl_Companies.db';
my $schema = PerlCompanies::DB->connect( "dbi:SQLite:dbname=$db_file", '', '',
    { sqlite_unicode => 1 } );

$schema->deploy unless -e $db_file;    # deploy the database if the file is new

my $iter = path($dir)->iterator;       # grab an iterator to walk the files

while ( my $file = $iter->() ) {
    next unless $file->basename =~ /\.txt$/;

    state $job_rs    = $schema->resultset('Job');
    state $location_rs    = $schema->resultset('Location');
    state $company_rs    = $schema->resultset('Company');
    state $dt_parser = DateTime::Format::Natural->new();

    say "Working on $file";

    my $email = Email::Simple->new( $file->slurp_raw );

    next unless $email->header('From') eq 'jobs-admin@perl.org (Perl Jobs)';

    my $body = $email->body;

    my ($name) = $body =~ /^Company Name:\s+(.*)$/mi;

    unless ($name) {    # If there's no $name,
        say $EXCEPTIONS "$file";    # log it to a file to look at later.
        next;
    }

    my ($uri)      = $body =~ /^Online URL for this job:\s+(.*)$/mi;
    my ($title)    = $body =~ /^Job title:\s+(.*)$/mi;
    my ($posted)   = $body =~ /^Posted:\s+([a-z]+ \s+ \d+, \s+ \d+)/mix;
    my ($location) = $body =~ /^Location:\s+(.*)$/mi;
    my ($hours)    = $body =~ /^Hours:\s+(.*)$/mi;
    my ($onsite)   = $body =~ /^Onsite:\s+(.*)$/mi;
    my ($terms)    = $body =~ /^Terms of employment:\s+(.*)$/mi;

    $posted = $dt_parser->parse_datetime($posted);

    $location ||= '[Missing]';

    my $remote = not( $onsite eq 'yes' );

    my $job = $job_rs->find_or_create(
        {
            uri    => $uri,
            posted => DateTime::Format::SQLite->format_datetime($posted),
            title  => $title,
            hours   => $hours,    # full-time / part-time
            terms   => $terms,    # contractor or direct-hire
            remote  => $remote,
            company => {
                name => $name,
            },
            filename => $file->basename,
        }
    );
    my $location_row = $location_rs->find_or_create({name => $location});
    unless ($location_row->companies->find($job->company->id)) {
        $location_row->add_to_companies({ id => $job->company->id });
    }
}

