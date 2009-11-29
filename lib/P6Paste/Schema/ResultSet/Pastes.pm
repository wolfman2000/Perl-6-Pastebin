package P6Paste::Schema::ResultSet::Pastes;

use strict;
use warnings;
use DateTime;
use parent 'DBIx::Class::ResultSet';

sub add_paste() # Return the new paste ID.
{
    my ($self, $uid, $subject, $content, $dead, $ip) = @_;
    my $done;
    my $now = DateTime->now;
    if (defined $dead and length $dead)
    {
        # Perl map usage here: map the time chosen.
        my @time;
        $time[30] = { minutes => 30 };
        $time[$_ * 60] = { hours => $_ } for 1,2,4,8,12;
        $time[$_ * 1440] = { days => $_ } for 1,2;
        $time[$_ * 10080] = { weeks => $_ } for 1,2;
        $time[$_ * 40320] = { months => $_ } for 1,2,6;
        $time[$_ * 483840] = { years => $_} for 1,100;

        $done = DateTime->now->add($time[$dead] );
    }
    my $ins = {
        user_id => $uid,
        subject => $subject,
        content => $content,
        tcheck => join(" ", split(/T/, $now)),
        expires => defined $done ? join(" ", split(/T/, $done)) : undef,
        ip => $ip,
    };
    return $self->create($ins)->id;
}

sub get_valid_paste()
{
    my ($self, $pid) = @_;
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

__END__

=head1 DESCRIPTION

This ResultSet contains added functionality to the default Pastes ResultSet.

=head1 METHODS

=head2 add_paste

Adds a paste to the database. Returns the ID of the new paste.

=head2 get_valid_paste

Retrieves the paste content based on the ID. If the ID does not
exist or the paste is past its expiration date, it returns nothing.

=head2 get_recent_pastes

Retrieves the recently made pastes that are available for
public viewing. Right now 10 is hardcoded as a limit, but this number
may change in the future.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework
  
=head2 L<DBIx::Class> - The DBIC framework

=head2 L<P6Paste::Schema::Result::Pastes> - The Pastes Table

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
