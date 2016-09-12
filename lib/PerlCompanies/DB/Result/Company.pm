package PerlCompanies::DB::Result::Company;
use DBIx::Class::Candy
  -perl5     => v10,
  -autotable => v1;

primary_column id => {
    data_type => 'int',
    auto_increment => 1,
    is_numeric => 1,
};

column name => {
    data_type => 'text',
    retrieve_on_insert => 1,
};

has_many company_location => 'PerlCompanies::DB::Result::CompanyLocation' => 'company_id';
many_to_many locations => company_location => 'location';

has_many job_postings => 'PerlCompanies::DB::Result::Job' => 'company_id';

sub location {
    my @locations = shift->locations;
    return $locations[0]->name;
}

sub most_recent_posting {
    shift->job_postings->search({}, {order_by => 'posted'})->first->posted;
}

sub hiring_status {
    my $last = shift->most_recent_posting;
    my $delta = $last->delta_md(DateTime->now);
    if ($delta->in_units('years') < 5) {
        return 'Active';
    }
    if ($delta->in_units('years') < 10) {
        return 'Dormant'
    }
    return 'Inactive';
}

1;
