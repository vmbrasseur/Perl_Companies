package PerlCompanies::DB::Result::Company;
use DBIx::Class::Candy
  -perl5      => v10,
  -components => [qw/InflateColumn::DateTime/],
  -autotable  => v1;

use DateTime;

primary_column id => {
    data_type      => 'int',
    auto_increment => 1,
    is_numeric     => 1,
};

unique_column name => {
    data_type          => 'text',
    retrieve_on_insert => 1,
};

column ctime => {
    data_type => 'datetime',
    default_value => \'CURRENT_TIMESTAMP',
};

column source => {
    data_type => 'text',
};

has_many 'company_location', 'PerlCompanies::DB::Result::CompanyLocation', 'company_id';
many_to_many locations => company_location => 'location';
has_many job_postings => 'PerlCompanies::DB::Result::Job' => 'company_id';

sub location {
    my @locations = shift->locations;
    return $locations[0]->name;
}

sub most_recent_posting {
    if (my $job = shift->job_postings->search( {}, { order_by => 'posted' } )->first) {
        return $job->posted;
    }
    return;
}

sub hiring_status {
    my $last  = shift->most_recent_posting;
    my $delta = $last->delta_md( DateTime->now );
    if ( $delta->in_units('years') < 5 ) {
        return 'Active';
    }
    if ( $delta->in_units('years') < 10 ) {
        return 'Dormant';
    }
    return 'Inactive';
}

1;
