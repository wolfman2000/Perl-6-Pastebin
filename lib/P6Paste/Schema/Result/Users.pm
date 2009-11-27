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

__END__

=head1 DESCRIPTION

The users table contains the list of all of the users that have
been recognized within the system. Users can either be
registered or not.

=head1 COLUMNS

=head2 id

This is the traditional primary id column.

=head2 uname

This is the username of the person. 32 IRC compatible characters
are allowed. This field is required.

=head2 email

This field is required if the user wishes to register. The
email address (up to 320 charaters) must be valid.

=head2 pword

This field is required if the user wishes to register. This
is a hashed/salted field.

=head2 created

This field shows when the nickname was first created. This
could be useful for record keeping.

=head1 SEE ALSO

=head2 L<Catalyst> - The Catalyst framework

=head2 L<DBIx::Class> - The DBIC framework

=head1 AUTHOR

Jason Felds

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
    
=cut
