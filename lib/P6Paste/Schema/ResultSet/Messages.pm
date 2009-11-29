package P6Paste::Schema::ResultSet::Messages;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_rand_message
{
    my ($self, $cat) = @_; # Force array context.
    my %srch = ('me.cat_id' => $cat);
    my %attr = ('select' => ['message'], 'order_by' => 'RANDOM() LIMIT 1');
    return $self->search(\%srch, \%attr)->single->message;
}

1;

__END__

=head1 DESCRIPTION

This ResultSet adds extra functionality to the Messages table.

=head1 METHODS

=head2 get_rand_message

Returns a random message given the category ID.

There is no sanity checking at this time.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework
  
=head2 L<DBIx::Class> - The DBIC framework

=head2 L<P6Paste::Schema::Result::Messages> - The Messages Table

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
