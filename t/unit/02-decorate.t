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

my $nbsp = chr( 160 );

my @dbi_csv_args = (
    "dbi:CSV:", undef, undef, {
        f_ext      => ".csv/r",
        f_dir      => "t/data/",
        RaiseError => 1,
    }
);
my ($dbh, $table);
$dbh   = DBI->connect ( @dbi_csv_args );
$table = DBIx::HTML->connect( $dbh );

is output( 'select * from test', { map_headers => sub { ucfirst } }  ),
    '<table><tr><th>Id</th><th>Parent</th><th>Name</th><th>Description</th></tr><tr><td>1</td><td>&nbsp;</td><td>root</td><td>the root</td></tr><tr><td>2</td><td>1</td><td>kid1</td><td>some kid</td></tr><tr><td>3</td><td>1</td><td>kid2</td><td>some other kid</td></tr><tr><td>4</td><td>2</td><td>grandkid1</td><td>a grandkid</td></tr><tr><td>5</td><td>3</td><td>grandkid2</td><td>another grandkid</td></tr><tr><td>6</td><td>3</td><td>greatgrandkid1</td><td>a great grandkid</td></tr></table>',
    "able to decorate headers with ucfirst()"
;

is output( 'select id from test', { map_headers => sub { uc } } ),
    '<table><tr><th>ID</th></tr><tr><td>1</td></tr><tr><td>2</td></tr><tr><td>3</td></tr><tr><td>4</td></tr><tr><td>5</td></tr><tr><td>6</td></tr></table>',
    "able to decorate with uc()";



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
