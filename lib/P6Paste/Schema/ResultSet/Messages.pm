package P6Paste::Schema::ResultSet::Messages;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_rand_message()
{
    my ($self, $cat) = @_; # Force array context.
    my %srch = ('me.cat_id' => $cat);
    my %attr = ('select' => ['message'], 'order_by' => 'RANDOM() LIMIT 1');
    return $self->search(\%srch, \%attr)->single->message;
}

1;
