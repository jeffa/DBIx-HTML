DBIx-HTML
=========
SQL queries to HTML tables.

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
Features are currently limited, but are being actively being added in. While you
can execute queries and generate HTML tables, there currently is no support for
critical features like supplying class names for tags. There might not be support
for calculating totals or subtotals as these can be obtain from DBIx::XHTML_Table.

See [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/) for more features.
```perl
use DBIx::HTML;

# database credentials - fill in the blanks
my @creds = ( $data_source, $usr, $pass );
my $table = DBIx::HTML->connect( @creds )

$table->do("
    select foo from bar
    where baz='qux'
    order by foo
");

print $table->generate;

# stackable method calls:
print DBIx::HTML
    ->connect( @creds )
    ->do('select foo,baz from bar')
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
