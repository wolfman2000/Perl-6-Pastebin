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

=head1 DESCRIPTION

The pastes table contains all of the pastes that were submitted
by users. If possible, the pastes will receive syntax highlighting.
Otherwise, they will appear unformatted.

=head1 COLUMNS

=head2 id

This is the traditional primary id column.

=head2 user_id

This is the ID of the person that created the paste.
If the person chose to remain anonymous, it is assigned
to the anonymous account. If the person was unregistered
and someone took the name, those old pastes become
assigned to the orphaned account.

=head2 subject

This is a short subject/question relating to the paste.

=head2 content

This is the paste content itself.

=head2 tcheck

This is when the paste was put into the database.

=head2 expires

This is when the paste expires, and thus becomes
unavailable for public viewing.

=head2 ip

This is the IP address of the user. The field can
accept IPv6 addresses, even though I am not aware
of many systems that use IPv6.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework

=head2 L<DBIx::Class> - The DBIC framework

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
    
=cut
