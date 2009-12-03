package P6Paste::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

P6Paste::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    if (defined $c->session->{id})
    {
        $c->response->status(409);
        $c->stash->{template} = 'login_nope.tt2';
        return;
    }
    
    $c->stash->{template} = 'login.tt2';
}

sub submit :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    
    
    $c->stash->{template} = 'login_try.tt2';
}


=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
