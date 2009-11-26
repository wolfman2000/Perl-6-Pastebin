package P6Paste::Schema::Result::PasteTags;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("paste_tags");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "paste_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "tag_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");


# Belongs to both Tags and Pastes.

__PACKAGE__->belongs_to('pastes' => 'P6Paste::Schema::Result::Pastes',
{ 'foreign.id' => 'self.paste_id' });
__PACKAGE__->belongs_to('tags' => 'P6Paste::Schema::Result::Tags',
{ 'foreign.id' => 'self.tag_id' });

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NrMwQ1EYrigz7uWRz9S7kQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
