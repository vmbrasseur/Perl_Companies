package PerlCompanies::DB::Result::CompanyLocation;
use DBIx::Class::Candy
  -perl5     => v10,
  -autotable => v1;

primary_column company_id => {
    data_type      => 'int',
    is_numeric     => 1,
    is_foreign_key => 1,
};

primary_column location_id => {
    data_type      => 'int',
    is_numeric     => 1,
    is_foreign_key => 1,
};

belongs_to company  => 'PerlCompanies::DB::Result::Company'  => 'company_id';
belongs_to location => 'PerlCompanies::DB::Result::Location' => 'location_id';

1;
