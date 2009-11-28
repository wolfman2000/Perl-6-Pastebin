package P6Paste::Schema::Result::Messages;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("messages");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "cat_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "message",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 256,
  },
);
__PACKAGE__->set_primary_key("id");

# Messages belong to categories.

__PACKAGE__->belongs_to('mess_categories' => 'P6Paste::Schema::Result::MessCategories',
{ 'foreign.id' => 'self.cat_id' });

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VSH/q97ciYaJkD5AFKYI/Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;

=head1 DESCRIPTION

The messages table contains all of the messages within
the application. These messages are generally called upon
by the application whenever something informative and/or fun
wants to be said.

=head1 COLUMNS

=head2 id

This is the traditional primary id column.

=head2 cat_id

This is the ID of the message category.

=head2 message

This is the message itself to be displayed.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework

=head2 L<DBIx::Class> - The DBIC framework

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
    
=cut
