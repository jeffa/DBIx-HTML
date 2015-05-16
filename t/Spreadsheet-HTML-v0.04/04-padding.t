#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Data::Dumper;

use DBIx::HTML;

my $data = [
    [ qw( a b c d ) ],
    [ qw( a b c ) ],
    [ qw( a b ) ],
    [ qw( a ) ],
    [ qw( a b c d e f g) ],
];
my $expected = [
    [ ['a'], ['b'], ['c'], ['d'], ],
    [ qw( a b c &nbsp; ) ],
    [ qw( a b &nbsp; &nbsp; ) ],
    [ qw( a &nbsp; &nbsp; &nbsp; ) ],
    [ qw( a b c d e f g) ],
];

my $table = new_ok 'DBIx::HTML', [ data => $data ];
is_deeply [ $table->process_data ], $expected,      "padding is correct";
