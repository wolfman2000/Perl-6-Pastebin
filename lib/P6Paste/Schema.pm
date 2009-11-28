package P6Paste::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HL3EhRb4rqLfBckEr6nnUw


# You can replace this text with custom content, and it will be preserved on regeneration
1;

=head1 DESCRIPTION

This file loads all of the tables from the database.

=head1 TABLES

=over

=item L<P6Paste::Schema::Result::Users>

This is the table of users.

=item L<P6Paste::Schema::Result::Pastes>

This is the table of pastes submitted.

=item L<P6Paste::Schema::Result::Tags>

This is the table of searchable tags (to be fully implemented later).

=item L<P6Paste::Schema::Result::PasteTags>

This table links Pastes and Tags.

=item L<P6Paste::Schema::Result::MessCategories>

This table contains message categories for displaying messages.

=item L<P6Paste::Schema::Result::Messages>

This table contains the messages to be displayed at certain times.

=back

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework

=head2 L<DBIx::Class> - The DBIC framework

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
    
=cut
