package P6Paste::Schema::Result::Tags;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("tags");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "tag",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
);
__PACKAGE__->set_primary_key("id");

# Tags have many paste_tags.

__PACKAGE__->has_many('paste_tags', 'P6Paste::Schema::Result::PasteTags', { 'foreign.tag_id' => 'self.id' });

# Tie tags to pastes.

__PACKAGE__->many_to_many('pastes' => 'paste_tags', 'pastes');

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:90XeFX/xCePkNSxu59xbiQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;

=head1 DESCRIPTION

The tags table contains the list of all of the tags that
were created for the pastes. These tags are to be used
for searching in the future.

=head1 COLUMNS

=head2 id

This is the traditional primary id column.

=head2 tag

This is the name of the tag. 32 characters
are allowed. This field is required.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework

=head2 L<DBIx::Class> - The DBIC framework

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
    
=cut
