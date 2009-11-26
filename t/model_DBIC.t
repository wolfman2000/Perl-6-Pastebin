#!perl
use strict;
use warnings;
use Test::More; # tests => 1;
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN { use_ok 'P6Paste::Schema' }

my $filename = 'tmp.db';

my $schema = P6Paste::Schema->connect("dbi:SQLite:dbname=$filename");
$schema->deploy;

my $us = $schema->resultset('Users');

$us->create(
{ uname => 'Anonymous', email => 'jafelds@feather.perl6.nl', created => '2009-11-01 00:00:00',
pword => 'ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB', }
);

is($us->find(1)->uname, 'Anonymous', 'Name sanity via primary key');

my %sql = ( 'email' => 'jafelds@feather.perl6.nl' );

is($us->search(\%sql , { 'columns' => 'uname' })->first->uname, 'Anonymous', 'Name sanity via search.');


my $pa = $schema->resultset('Pastes');

$pa->create(
{ 'user_id' => 1, 'subject' => '', 'content' => q{use v6;\r\n\r\nsay \"Hello World!\";},
 'tcheck' => '2009-11-11 02:58:16', 'ip' => '193.200.132.135', }
);

my %sql = ( 'users.uname' => 'Anonymous' ); 
my %attr = (
    join => 'users',
    columns => ['me.ip'],
);

is($pa->search(\%sql , \%attr)->first->ip, '193.200.132.135', 'IP test');


%attr = (
    join => 'users',
#    select => [ qw(me.expires users.uname) ],
#    as => [ qw(anno expires uname) ],
    columns => [ qw(me.expires users.uname) ],
);

is($pa->find({ 'me.id' => 1}, \%attr )->users->uname, 'Anonymous', 'Multi join');

$pa->create(
{ 'user_id' => 1, 'subject' => 'Trying again', 'content' => q{use v6;\r\n\r\nsay rand 1 * 6;},
 'tcheck' => '2009-11-11 05:08:41', 'ip' => '193.200.132.135', }
);

# The initial troublesome query. Now tamed.

my $sql = q{expires IS NULL OR datetime(tcheck, '+' || expires || ' minutes') > datetime('now')};
%attr = (
    prefetch => 'users',
);

my $tmp = $pa->search(\$sql, \%attr);


is(scalar $tmp->all, 2, 'Ensure 2 records came through multi join test.');

while (my $row = $tmp->next())
{
    is($row->users->uname, 'Anonymous', 'Check name matching.');
}

done_testing;
END { unlink $filename }

