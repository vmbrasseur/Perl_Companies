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

column ctime => {
    data_type => 'datetime',
    default_value => \'CURRENT_TIMESTAMP',
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

column company_id => {
    data_type => 'int',
    is_numeric => 1,
    is_foreign_key => 1,
};

belongs_to company => 'PerlCompanies::DB::Result::Company' => 'company_id';
1;
