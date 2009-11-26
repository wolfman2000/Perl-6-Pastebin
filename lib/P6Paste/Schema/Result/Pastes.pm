package P6Paste::Schema::Result::Pastes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("pastes");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "user_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "subject",
  {
    data_type => "VARCHAR",
    default_value => "NULL",
    is_nullable => 1,
    size => 256,
  },
  "content",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "tcheck",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "expires",
  {
    data_type => "VARCHAR",
    default_value => "NULL",
    is_nullable => 1,
    size => 19,
  },
  "ip",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 39,
  },
);
__PACKAGE__->set_primary_key("id");

# Each paste belongs to one author..
__PACKAGE__->belongs_to('users', 'P6Paste::Schema::Result::Users', { 'foreign.id' => 'self.user_id' });

# Pastes have many paste tags.
__PACKAGE__->has_many('paste_tags', 'P6Paste::Schema::Result::PasteTags', { 'foreign.paste_id' => 'self.id' });

# Tie Pastes to Tags.
__PACKAGE__->many_to_many('tags' => 'paste_tags', 'tags');

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H0qqcLbxZBFeck7krIVKug


# You can replace this text with custom content, and it will be preserved on regeneration
1;
