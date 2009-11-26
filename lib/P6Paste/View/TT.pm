package P6Paste::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [ P6Paste->path_to('root', 'src'), ],
    TIMER => 0,
    WRAPPER => 'wrapper.tt2',
    ENCODING => 'UTF-8',
);

=head1 NAME

P6Paste::View::TT - TT View for P6Paste

=head1 SYNOPSIS

See L<P6Paste>

=head1 DESCRIPTION

TT View for P6Paste

=head1 AUTHOR

Jason Felds,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

