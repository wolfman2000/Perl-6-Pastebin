use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use P6Paste::Schema;

my $dbfile = shift;
$dbfile //= 'myappTEST.db';

my $schema = P6Paste::Schema->connect("dbi:SQLite:dbname=$dbfile");

$schema->deploy();

$schema->resultset("MessCategories")->populate([
	{
		id => 1, name => 'regerror', messages => [
			{message => 'One day, we will have our group of infinite monkeys make a better version of this code.'},
			{message => 'I apologize. Ada unleashed her Python (or was it ASP?) which Bashed into the Perl code with his Ruby teeth. See? Sharp fangs.'},
			{message => 'We are sorry. Your registration could not be completed as dialed. Please check the URL and try again.'},
		],
	},
	{
		id => 2, name => 'regsuccess', messages => [
			{message => 'Howdy friend! How would you like to be neighbors? Come jo--wait, you just did already! Nevermind. :)'},
			{message => 'Welcome to the neighborhood.'},
			{message => 'Ah, a new face. Welcome to the pastebin.'},
		],
	},
	{
		id => 3, name => 'pasteerror', messages => [
			{message => 'Crap...must have left the glue somewhere else. Hang on.'},
			{message => 'Please do not make me have to use duct tape for a pastebin.'},
			{message => 'We need an infinite amount of butterflies at this rate...'},
		],
	},
	{
		id => 4, name => 'pasteanon', messages => [
			{message => 'Ah, a new kid. Do not be afraid: we do not bite. Much. :)'},
			{message => 'Thanks for your contribution...who are you again? You must be new.'},
		],
	},
	{
		id => 5, name => 'pasteuser', messages => [
			{message => 'Just a little more...got it! Your paste is saved.'},
			{message => 'The butterflies in the back room thank you for contributing.'},
		],
	},
	{
		id => 6, name => 'pviewbadid', messages => [
			{message => 'I think we were looking into our telescope backwards or something...'},
			{message => 'Dag blasted pirates! They gave us a fake map! We cannot find the booty!'},
			{message => 'This is not good...the GPS is out of power!'},
		],
	},
]);

$schema->resultset("Users")->populate([
	{
		uname => 'Anonymous', email => 'jafelds@feather.perl6.nl', created => '2009-11-01 00:00:00',
		pword => 'ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB',
	},
	{
		uname => 'Orphaned', email => 'jafelds@ncsu.edu', created => '2009-11-01 00:00:00',
		pword => 'ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB',
	},
]);
