package P6Paste::Controller::Logout;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

P6Paste::Controller::Logout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    unless (defined $c->session->{id})
    {
        $c->stash->{template} = 'logout_nope.tt2';
        $c->response->status(409);
    }

    $c->response->body('Matched P6Paste::Controller::Logout in Logout.');
}


=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
