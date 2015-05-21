#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use DBIx::HTML;
use Test::More;

eval "use DBD::CSV";
plan skip_all => "DBD::CSV required" if $@;

plan tests => 1;

my $dbh = DBI->connect (
    "dbi:CSV:", undef, undef, {
        f_ext      => ".csv/r",
        f_dir      => "t/data/",
        RaiseError => 1,
    }
);
my $output = DBIx::HTML
    ->connect($dbh)
    ->do( 'select * from decorate' )
    ->transpose
;

is $output,
    '<table><tr><th>col_1</th><td>1</td><td>4</td><td>7</td></tr><tr><th>col_2</th><td>2</td><td>5</td><td>8</td></tr><tr><th>col_3</th><td>3</td><td>6</td><td>9</td></tr></table>',
    "able to transpose table"
;
