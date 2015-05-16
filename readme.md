DBIx-HTML
=========
SQL queries to HTML tables.

This module is an adapter between the older DBIx::XHTML_Table
and the newer Spreadsheet::HTML. It will eventually only
leverage the latter, essentially providing HTML output while
allowing the former to continue to provide XHTML output.

The goal is to slowly move usage away from DBIx::XHTML_Table
and over to DBIx::HTML and Spreadsheet::HTML while allowing
DBIx::XHTML_Table to remain available for legacy purposes.

See [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/)
and [Spreadsheet::HTML](http://search.cpan.org/dist/Spreadsheet-HTML/)
for more information.

Installation
------------
To install this module, you may run the
[classic CPAN process](http://perldoc.perl.org/ExtUtils/MakeMaker.html#Default-Makefile-Behaviour):
```
perl Makefile.PL
make
make test
make install
```

Synopsis
--------
```perl
use DBIx::HTML;

# database credentials - fill in the blanks
my @creds = ( $data_source, $usr, $pass );

my $table = DBIx::HTML->new( @creds )

$table->execute("
    select foo from bar
    where baz='qux'
    order by foo
");

print $table->generate;

# stackable method calls:
print DBIx::HTML
    ->new( @creds )
    ->execute('select foo,baz from bar')
    ->generate;
```

Support and Documentation
-------------------------
After installing, you can find documentation for this module with the
perldoc command.
```
perldoc DBIx::HTML
```
You can also look for information at
[Search CPAN](http://search.cpan.org/dist/DBIx-HTML/)

License and Copyright
---------------------
See [source POD](/lib/DBIx/HTML.pm).
