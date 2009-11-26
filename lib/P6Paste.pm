package P6Paste;

use strict;
use warnings;

use Catalyst::Runtime 5.80;
use HTTP::BrowserDetect;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Unicode
                Static::Simple
		StackTrace
		Authentication
		Session
		Session::Store::FastMmap
		Session::State::Cookie/;
our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in p6paste.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
	name => 'P6Paste',
	'Plugin::Session' => { cookie_expires => 2592000, },
);
__PACKAGE__->config->{static}->{ignore_extensions} = [];

# Start the application
__PACKAGE__->setup();


=head1 NAME

P6Paste - Catalyst based application

=head1 SYNOPSIS

    script/p6paste_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<P6Paste::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
