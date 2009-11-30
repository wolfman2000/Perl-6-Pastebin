package P6Paste::Controller::Register;

use utf8;
use strict;
use warnings;
use Regexp::Common qw<Email::Address>;
use Email::Address;
use parent 'Catalyst::Controller';

=head1 NAME

P6Paste::Controller::Register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 validate

Validate submitted data via normal form processing.

=cut

sub validate :Local :Args(0) {
    my ($self, $c) = @_;
    
    unless (defined $c->request->params->{submit})
    {
        $c->stash->{template} = 'val_get.tt2';
        $c->response->status(405); # Must be POST
	return;
    }
    
    my $uname = $c->request->params->{regUser};
    my $pass1 = $c->request->params->{regPass1};
    my $pass2 = $c->request->params->{regPass2};
    my $email = $c->request->params->{regEmail};
    
    my @errors = ();
    
    # Validate username.
        
    unless (length $uname)
    {
        push @errors, "You must provide a username to register.";
    }
    elsif ($uname !~ /^[0-9a-zA-Z_\|\`\-\^\{\}]{1,32}$/)
    {
        push @errors, "Your username contains illegal characters.";
    }
    elsif ($c->model('DBIC::Users')->is_name_taken($uname))
    {
        push @errors, "The requested username is not available.";
    }
    
    # Validate email.
    
    unless (length $email)
    {
        push @errors, "You must provide an email address.";
    }
    elsif ($email !~ /($RE{Email}{Address})/g)
    {
        push @errors, "You must provide a valid email address.";
    }
    elsif ($c->model('DBIC::Users')->is_email_taken($email))
    {
        push @errors, "The requested email address is not available.";
    }
    
    # Validate passwords.
    
    unless (length $pass1)
    {
        push @errors, "You must provide a password to protect your account.";
    }
    elsif (length $pass1 < 6)
    {
        push @errors, "Your password must be at least 6 characters.";
    }
    elsif ($pass1 ne $pass2)
    {
        push @errors, "Your password and confirmation password must match.";
    }
    

    my $errs = scalar @errors;
    
    if ($errs)
    {
        $c->response->status(409);
        $c->stash->{regError} = \@errors;
    }
    else
    {
        $c->model('DBIC::Users')->add_registered($uname, $pass1, $email);
    }
    $c->stash->{funny} = $c->model('DBIC::Messages')->get_rand_message($errs ? 1 : 2);
    $c->stash->{template} = 'validate.tt2';
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'register.tt2';    
}


=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
