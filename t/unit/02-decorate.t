#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use DBIx::HTML;
use Test::More;
use Data::Dumper;

eval "use DBD::CSV";
plan skip_all => "DBD::CSV required" if $@;

eval "use HTML::TableExtract";
plan skip_all => "HTML::TableExtract required" if $@;

plan tests => 2;

my $dbh = DBI->connect (
    "dbi:CSV:", undef, undef, {
        f_ext      => ".csv/r",
        f_dir      => "t/data/",
        RaiseError => 1,
    }
);
my $table = DBIx::HTML->connect( $dbh );

is output( 'select * from decorate', { filter_header => sub { ucfirst } }  ),
    '<table><tr><th>Col_1</th><th>Col_2</th><th>Col_3</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td></tr></table>',
    "able to decorate headers with sub"
;

is output( 'select col_2 as foo from decorate', { filter_header => sub { uc } } ),
    '<table><tr><th>FOO</th></tr><tr><td>2</td></tr><tr><td>5</td></tr><tr><td>8</td></tr></table>',
    "able to rename with SQL and decorate";



sub output {
    my ($query, $table_attrs) = @_;
    my $output = DBIx::HTML
        ->connect($dbh)
        ->do( $query )
        ->decorate( %{ $table_attrs || {} } )
        ->generate
    ;
    return $output;
}
