package PerlCompanies::DB;
use 5.10.1;

use parent qw(DBIx::Class::Schema);

our $VERSION = '1';

 __PACKAGE__->load_namespaces();

  1;
