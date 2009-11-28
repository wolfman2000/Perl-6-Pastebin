use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use P6Paste::Schema;

my $schema = P6Paste::Schema->connect('dbi:SQLite:dbname=foo.db');

$schema->deploy();

