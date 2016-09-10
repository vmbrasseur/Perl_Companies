package PerlCompanies::DB::Result::Location;
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

has_many company_location => 'PerlCompanies::DB::Result::CompanyLocation' => 'location_id';
many_to_many companies => company_location => 'company';

1;
