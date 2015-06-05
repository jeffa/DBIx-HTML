#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use DBIx::HTML;
use Test::More;

eval "use DBD::CSV 0.48";
plan skip_all => "DBD::CSV 0.48 required" if $@;

plan tests => 1;

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

is $table->reverse,
    '<table><tr><td>9</td><td>8</td><td>7</td></tr><tr><td>6</td><td>5</td><td>4</td></tr><tr><td>3</td><td>2</td><td>1</td></tr><tr><th>Col 3</th><th>Col 2</th><th>Col 1</th></tr></table>',
    "able to reverse table"
;
