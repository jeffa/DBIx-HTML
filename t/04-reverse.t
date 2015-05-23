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

my $table = DBIx::HTML
    ->connect( $dbh )
    ->do( 'select * from decorate' )
;

SKIP: {
    skip "not ready until Spreadsheet::HTML v0.08 released", 1;
is $table->reverse,
    '<table><tr><td>7</td><td>8</td><td>9</td></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><th>col_1</th><th>col_2</th><th>col_3</th></tr></table>',
    "able to transpose table"
;
};
