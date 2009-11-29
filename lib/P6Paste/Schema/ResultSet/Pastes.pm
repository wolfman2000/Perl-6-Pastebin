package P6Paste::Schema::ResultSet::Pastes;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub get_valid_paste()
{
    my ($self, $pid) = @_; # Force array context.
    my %srch = ('me.id' => $pid, expires => [undef, {'>', => \q<datetime('now')> }]);
    my %attr = (join => 'users',
        select => [qw<me.subject me.content me.tcheck users.uname me.user_id users.pword>], );
    return $self->search(\%srch, \%attr)->first;
}

sub get_recent_pastes()
{
    my $self = shift;
    my $srch = {expires => [undef, {'>', => \q<datetime('now')> }] };
    my $attr = { prefetch => 'users', order_by => 'tcheck DESC LIMIT 10' };
    return $self->search($srch, $attr);
}

1;
