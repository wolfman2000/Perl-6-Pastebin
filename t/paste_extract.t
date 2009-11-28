#!perl
use strict;
use warnings;
use Test::More tests => 1;
use FindBin;
use lib "$FindBin::Bin/../lib";
use STD;
use Syntax::Highlight::Perl6;

BEGIN { use_ok 'P6Paste::Schema' }


my $schema = P6Paste::Schema->connect("dbi:SQLite:dbname=p6paste.db");

my $sql = q{expires IS NULL OR datetime(tcheck, '+' || expires || ' minutes') > datetime('now')};

my %attr = (
    join => 'users',
    select => [ qw<me.subject me.content me.tcheck users.uname me.user_id users.pword> ]
);

my $txt = $schema->resultset('Pastes')->search(\$sql, \%attr )->first->content;

print $txt;

done_testing;

