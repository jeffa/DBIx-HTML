DBIx-HTML
=========
SQL queries to HTML tables.

See [DBIx::HTML](http://search.cpan.org/dist/DBIx-HTML/)
and [Spreadsheet::HTML](http://search.cpan.org/dist/Spreadsheet-HTML/)
for more information.

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
You can also find documentation at [metaCPAN](https://metacpan.org/pod/DBIx::HTML).

License and Copyright
---------------------
See [source POD](/lib/DBIx/HTML.pm).
