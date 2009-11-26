package P6Paste::Schema::Result::MessCategories;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("mess_categories");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 16,
  },
);
__PACKAGE__->set_primary_key("id");

# Categories can have many messages.

__PACKAGE__->has_many('messages', 'P6Paste::Schema::Result::Messages', { 'foreign.cat_id' => 'self.id' });

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-14 03:10:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5wztxRu1rrTdKTQAk9jC7g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
