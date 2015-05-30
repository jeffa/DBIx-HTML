#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use DBIx::HTML;
use Test::More;

eval "use DBD::CSV 0.48";
plan skip_all => "DBD::CSV 0.48 required" if $@;

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

is $table->transpose,
    '<table><tr><th>Col 1</th><td>1</td><td>4</td><td>7</td></tr><tr><th>Col 2</th><td>2</td><td>5</td><td>8</td></tr><tr><th>Col 3</th><td>3</td><td>6</td><td>9</td></tr></table>',
    "able to transpose table"
;

is $table->transpose( table => { class => 'foo' } ),
    '<table class="foo"><tr><th>Col 1</th><td>1</td><td>4</td><td>7</td></tr><tr><th>Col 2</th><td>2</td><td>5</td><td>8</td></tr><tr><th>Col 3</th><td>3</td><td>6</td><td>9</td></tr></table>',
    "able to pass table attrs"
;
