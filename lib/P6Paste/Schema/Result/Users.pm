package P6Paste::Schema::Result::Users;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "uname",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 320,
  },
  "pword",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 64 },
  "created",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");

# Each user can have many pastes.
__PACKAGE__->has_many('pastes' => 'P6Paste::Schema::Result::Pastes', 
{ 'foreign.user_id' => 'self.id' });

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OPJLf4aLdX+e0eoWJXsCaA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
