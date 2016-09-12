package PerlCompanies::DB::Result::Job;
use DBIx::Class::Candy
  -perl5     => v10,
  -components => [qw/InflateColumn::DateTime/],
  -autotable => v1;

primary_column uri => {
    data_type => 'text',
};

column title => {
    data_type => 'text',
};

column posted => {
    data_type => 'datetime',
};

column hours => {
    data_type => 'text',
    is_nullable => 1,
};

column terms => {
    data_type => 'text',
    is_nullable => 1,
};

column remote => {
    data_type => 'bool',
    default => 0,
};

column filename => {
    data_type => 'text',
};

column company_id => {
    data_type => 'int',
    is_numeric => 1,
    is_foreign_key => 1,
};

belongs_to company => 'PerlCompanies::DB::Result::Company' => 'company_id';
1;
