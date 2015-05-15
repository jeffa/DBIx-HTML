#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'DBIx::HTML' ) || print "Bail out!\n";
}

diag( "Testing DBIx::HTML $DBIx::HTML::VERSION, Perl $], $^X" );
