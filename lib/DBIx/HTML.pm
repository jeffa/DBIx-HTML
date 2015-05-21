package DBIx::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.08';

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
    return $self;
}

sub generate    { _generator( shift )->generate( @_ )  }
sub portrait    { _generator( shift )->generate( @_ )  }
sub transpose   { _generator( shift )->transpose( @_ ) }
sub landscape   { _generator( shift )->transpose( @_ ) }
sub reverse     { _generator( shift )->reverse( @_ )   }

sub _generator  {
    my $self = shift;
    return Spreadsheet::HTML->new( data => [ $self->{head}, @{ $self->{rows} } ] );
 }


# disconnect database handle if i created it
sub DESTROY {
	my $self = shift;
	if (!$self->{keep_alive} and UNIVERSAL::isa( $self->{dbh}, 'DBI::db' )) {
        $self->{dbh}->disconnect();
	}
}


1;
__END__
=head1 NAME

DBIx::HTML - SQL queries to HTML tables.

=head1 THIS IS AN ALPHA RELEASE.

While most functionality for this module has been completed,
testing has not. This module has a strong dependency on
L<Spreadsheet::HTML> which currently is also an alpha release.

You are encouraged to try my older L<DBIx::XHTML_Table> during
the development of this module.

=head1 USAGE

    use DBIx::HTML;

    my $table = DBIx::HTML->connect( @db_credentials );
    $table->do( $query );
    print $table->generate;

    # stackable method calls:
    print DBIx::HTML
        ->connect( @db_credentials )
        ->do( 'select foo,baz from bar' )
        ->generate
    ;

=head1 METHODS

=over 4

=item connect( @database_credentials )

Connects to the database. See L<DBI> for how to do that.
Optionally, create your own database handle and pass it:

  my $dbh = DBI->connect ( @db_creds );
  my $table = DBIx::HTML->connect( $dbh );

  # do stuff and then finally ...
  $dbh->disconnect;

DBIx::HTML will not disconnect your database handle.

=item do( $sql_query )

Executes the query, fetches the results and stores
them internally.

=item portrait( key => 'value' )

=item generate( key => 'value' )

Produce and return the HTML table with headers at top.

(See L<Spreadsheet::HTML> for available function arguments.)

=item landscape( key => 'value' )

=item transpose( key => 'value' )

Produce and return the HTML table with headers at left.

(See L<Spreadsheet::HTML> for available function arguments.)

=item reverse( key => 'value' )

Produce and return the HTML table with headers at bottom.

(See L<Spreadsheet::HTML> for available function arguments.)

=back

=head1 SEE ALSO

=over 4

=item L<Spreadsheet::HTML>

=item L<DBIx::XHTML_Table>

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

Thank you very much! :)

=over 4

=item * Neil Bowers

Helped with Makefile.PL suggestions and corrections.

=back

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
