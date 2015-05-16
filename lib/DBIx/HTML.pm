package DBIx::HTML::V1;
use base 'DBIx::XHTML_Table', 'DBIx::HTML';

package DBIx::HTML::V2;
use base 'Spreadsheet::HTML', 'DBIx::HTML';

package DBIx::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.02';

use Data::Dumper;

sub new {
    my $class = shift;

    if (!ref($_[0]) and $_[0] eq 'data') {
        return DBIx::HTML::V2->new( @_ ); 
    }
    elsif (ref($_[0]) eq 'HASH' and exists $_[0]->{data}) {
        return DBIx::HTML::V2->new( @_ ); 
    }

    return DBIx::HTML::V1->new( @_ ); 
}

1;
__END__
=head1 NAME

DBIx::HTML - SQL queries to HTML tables.

This module is an adapter between the older DBIx::XHTML_Table
and the newer Spreadsheet::HTML. It will eventually only
leverage the latter, essentially providing HTML output while
allowing the former to continue to provide XHTML output.

The goal is to slowly move usage away from DBIx::XHTML_Table
and over to DBIx::HTML/Spreadsheet::HTML while allowing
DBIx::XHTML_Table to remain available.

See L<DBIx::XHTML_Table> and L<Spreadsheet::HTML> for more information.

=head1 NEW USAGE (Spreadsheet::HTML)

New usage is currently limited. No database queries are executed
on behalf of the client currently, but this will change. For now,
focus is on allowing legacy usage to continue as-is.

    my $table = DBIx::HTML->new( data => $data );
    print $table->generate;
    print $table->transpose;
    print $table->reverse;

=head1 LEGACY USAGE (DBIx::XHTML_Table)

DBIx::HTML should be a full replacement for DBIx::XHTML_Table.

    use DBIx::HTML;

    # database credentials - fill in the blanks
    my @creds = ( $data_source, $usr, $pass );
    my $table = DBIx::HTML->new( @creds )

    $table->exec_query("
        select foo from bar
        where baz='qux'
        order by foo
    ");

    print $table->output;

    # stackable method calls:
    print DBIx::HTML
        ->new( @creds )
        ->exec_query('select foo,baz from bar')
        ->output;

=head1 METHODS

=over 4

=item new

If a hash or hash reference argument is present with
a key of 'data' then new() will return a V2 object
which is a subclass of Spreadsheet::HTML.

Otherwise, a V1 object will be returned, which is a 
subclass of DBIx::XHTML_Table.

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to

=over 4

=item * C<bug-dbix-html at rt.cpan.org>

    Send an email.

=item * L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIx-HTML>

    Use the web interface.

=back

I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIx::HTML

The Github project is L<https://github.com/jeffa/DBIx-HTML>

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-HTML>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBIx-HTML>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBIx-HTML>

=item * Search CPAN

L<http://search.cpan.org/dist/DBIx-HTML/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Jeff Anderson.

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
