package DBIx::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.05';

use DBI;
use Carp;
use Spreadsheet::HTML;
use Data::Dumper;

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
        eval { $self->{dbh} = DBI->connect(@_) };
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

sub generate {
    my $self = shift;
    return Spreadsheet::HTML
        ->new( data => [ $self->{head}, @{ $self->{rows} } ] )
        ->generate( $self->{table_attrs} )
    ;
}

sub decorate {
    my $self = shift;
    my %attrs = @_;

    if (my $func = delete $attrs{filter_header}) {
        $self->{head} = [ map $func->($_), @{ $self->{head} } ];
    }

    $self->{table_attrs} = {%attrs};
    return $self;
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

=head1 USAGE

    use DBIx::HTML;

    # database credentials - fill in the blanks
    my @creds = ( $data_source, $usr, $pass );
    my $table = DBIx::HTML->connect( @creds )

    $table->do('
        select foo from bar
        where baz = ?
        order by foo
    ', [ 'qux' ]);

    $table->decorate( table => { border => 1 } );

    print $table->generate;

    # stackable method calls:
    print DBIx::HTML
        ->connect( @creds )
        ->do( 'select foo,baz from bar' )
        ->decorate( table => { border => 1 } )
        ->generate;

=head1 METHODS

=over 4

=item connect()

Connects to the database. See L<DBI> for how to do that.

=item do()

Executes the query.

=item decorate()

Specify attributes for the HTML tags in the generated table.

=item generate()

Produce and return the HTML table.

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
