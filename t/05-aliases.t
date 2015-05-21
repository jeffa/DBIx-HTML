#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use DBIx::HTML;
use Test::More;

eval "use DBD::CSV";
plan skip_all => "DBD::CSV required" if $@;

plan tests => 2;

my $dbh = DBI->connect (
    "dbi:CSV:", undef, undef, {
        f_ext      => ".csv/r",
        f_dir      => "t/data/",
        RaiseError => 1,
    }
);

my $table = DBIx::HTML
    ->connect( $dbh )
    ->do( 'select * from decorate' )
;

is $table->generate, $table->portrait,      "generate() is portrait()";
is $table->landscape, $table->transpose,    "landscape() is transpose()";
