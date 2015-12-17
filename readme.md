DBIx::HTML
==========
Just another HTML table generating DBI extension. [![CPAN Version](https://badge.fury.io/pl/DBIx-HTML.svg)](https://metacpan.org/pod/DBIx::HTML) [![Build Status](https://api.travis-ci.org/jeffa/DBIx-HTML.svg?branch=master)](https://travis-ci.org/jeffa/DBIx-HTML)

See [DBIx::HTML](http://search.cpan.org/dist/DBIx-HTML/)
and [Spreadsheet::HTML](http://search.cpan.org/dist/Spreadsheet-HTML/)
for more information.

ALPHA RELEASE
-------------
While most functionality for this module has been completed,
testing has not. This module has a strong dependency on
[Spreadsheet:HTML](http://search.cpan.org/dist/Spreadsheet-HTML/)
which currently is also an alpha release.
(https://github.com/jeffa/Spreadsheet-HTML)

See [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/)
if you need a production ready solution and check back soon.

Synopsis
--------
```perl
use DBIx::HTML;

my $generator = DBIx::HTML->connect( @db_credentials );
$generator->do( $query );

# supports mulitple orientations
print $generator->portrait;
print $generator->landscape;

# stackable method calls:
print DBIx::HTML
    ->connect( @db_credentials )
    ->do( 'select foo,baz from bar' )
    ->landscape
;

# rotating attributes:
print $generator->portrait( tr => { class => [qw( odd even )] } );
```

Installation
------------
To install this module, you should use CPAN. A good starting
place is [How to install CPAN modules](http://www.cpan.org/modules/INSTALL.html).

If you truly want to install from this github repo, then
be sure and create the manifest before you test and install:
```
perl Makefile.PL
make
make manifest
make test
make install
```

Support and Documentation
-------------------------
After installing, you can find documentation for this module with the
perldoc command.
```
perldoc DBIx::HTML
```
You can also find documentation at [metaCPAN](https://metacpan.org/pod/DBIx::HTML).

License and Copyright
---------------------
See [source POD](/lib/DBIx/HTML.pm).
