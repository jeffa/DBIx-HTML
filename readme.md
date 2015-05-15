DBIx-HTML
=========

Rename of [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/).

This will be the future home of DBIx::XHTML_Table and as of now this 
module (DBIx::HTML) is merely a subclass of DBIx::XHMTL_Table. That 
means that the output will contain XHTML elements. Work will be done
to ensure that this module only emits XHTML if requested, while the
original DBIx::XHTML_Table will continue to work as specified.
Any methods that appear to have been renamed are clones. 

Installation
------------
To install this module, run the following commands:
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

You can also look for information at:

* [RT, CPAN's request tracker](http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-HTML) (report bugs here)

* [AnnoCPAN](http://annocpan.org/dist/DBIx-HTML) - annotated CPAN documentation

* [CPAN Ratings](http://cpanratings.perl.org/d/DBIx-HTML)

* [Search CPAN](http://search.cpan.org/dist/DBIx-HTML/)

License and Copyright
---------------------
Copyright (C) 2015 Jeff Anderson

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
