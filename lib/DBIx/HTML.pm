package DBIx::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.09';
our $AUTOLOAD;

use DBI;
use Carp;
use Spreadsheet::HTML;

sub connect {
    my $class = shift;
    my $self = {
        head        => [],
        rows        => [],
        dbh         => undef,
        sth         => undef,
        keep_alive  => undef,
        generator   => Spreadsheet::HTML->new(
            cache    => 1,        
            headings => sub { join(' ', map { ucfirst(lc($_)) } split ('_', shift)) }
        ),
    };

    if (UNIVERSAL::isa( $_[0], 'DBI::db' )) {
        # use supplied db handle
        $self->{dbh}        = $_[0];
        $self->{keep_alive} = 1;
    } else {
        # create my own db handle
        eval { $self->{dbh} = DBI->connect( @_ ) };
        carp $@ and return undef if $@;
    }

	return bless $self, $class;
}

sub do {
    my $self = shift;
    my ($sql, $args) = @_;

    carp "can't call do(): no database handle" unless $self->{dbh};

    eval {
        $self->{sth} = $self->{dbh}->prepare( $sql );
        $self->{sth}->execute( @$args );
    };
    carp $@ and return undef if $@;

    $self->{head} = $self->{sth}{NAME};
    $self->{rows} = $self->{sth}->fetchall_arrayref;
    $self->{generator}{data} = [ $self->{head}, @{ $self->{rows} } ];
    return $self;
}

sub AUTOLOAD {
    my $self = shift;
    croak "must connect() first" unless ref($self) eq __PACKAGE__;
    (my $method = $AUTOLOAD) =~ s/.*:://;
    croak "no such method $method for " . ref($self->{generator}) unless $self->{generator}->can( $method );
    return $self->{generator}->$method( @_ );
} 


# disconnect database handle if i created it
sub DESTROY {
	my $self = shift;
	if (!$self->{keep_alive} and $self->{dbh}->isa( 'DBI::db' )) {
        $self->{dbh}->disconnect();
	}
}


1;
__END__
=head1 NAME

DBIx::HTML - SQL queries to HTML5 tables.

=head1 USAGE

    use DBIx::HTML;

    my $table = DBIx::HTML->connect( @db_credentials );
    $table->do( $query );
    print $table->portrait( indent => "\t" );

    # stackable method calls:
    print DBIx::HTML
        ->connect( @db_credentials )
        ->do( 'select foo,baz from bar' )
        ->landscape( encodes => '<>' )
    ;

=head1 SYNOPSIS

Connect to the database and issue a query. The result will be
an HTML5 table containing the query results wrapped in <td> tags
and headings wrapped in <th> tags. Headings values have the first
character in each word upper cased, with underscores replaced by
spaces. All automatic settings can be overridden. This module uses
Spreadsheet::HTML to generate the tables. See L<Spreadsheet::HTML>
for further documentation on customizing the table output.

=head1 METHODS

=over 4

=item C<connect( @database_credentials )>

Connects to the database. See L<DBI> for how to do that.
Optionally, create your own database handle and pass it:

  my $dbh = DBI->connect ( @db_creds );
  my $table = DBIx::HTML->connect( $dbh );

  # do stuff and then finally ...
  $dbh->disconnect;

DBIx::HTML will not disconnect your database handle.

=item C<do( $sql_query )>

Executes the query, fetches the results and stores
them internally.

=back

=head1 SPREADSHEET::HTML METHODS

All methods from Spreadsheet::HTML are delegated. Simply call
any one of the methods provided and supply your own arguments.
For example, to group table rows into respective <thead>, <tbody>
and <tfoot> sections and to remove any headings text formatting:

  print $table->generate( tgroups => 1, headings => undef );

See L<Spreadsheet::HTML> for full documentation on these methods.

=head1 SEE ALSO

=over 4

=item L<Spreadsheet::HTML>

=item L<DBIx::XHTML_Table>

The original since 2001. Can handle advanced grouping, individual cell
value contol, rotating attributes and totals/subtotals.

=back

=head1 THIS IS AN ALPHA RELEASE.

While most functionality for this module has been completed,
testing has not. This module has a strong dependency on
L<Spreadsheet::HTML> which currently is also an alpha release.

You are encouraged to try my older L<DBIx::XHTML_Table> during
the development of this module.

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

=head1 GITHUB

The Github project is L<https://github.com/jeffa/DBIx-HTML>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIx::HTML

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

Thank you very much! :)

=over 4

=item * Neil Bowers

Helped with Makefile.PL suggestions and corrections.

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

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
