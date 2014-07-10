#!/usr/bin/perl -w

#
# save_playlist.pl
#
# Developed by Dinesh D <dinesh@exceleron.com>
# Copyright (c) 2014 Exceleron Inc
# Licensed under terms of GNU General Public License.
# All rights reserved.
#
# Changelog:
# 2014-07-07 - created
#

use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use JSON;
use Storable;
use Data::Dumper;

my $q = CGI->new;
print "Content-type: text/html\n\n";
my $ip = $ENV{REMOTE_ADDR} || "unknown" ;

if($q->param('action') eq "save"){
	my $data = decode_json($q->param('data'));
	store $data , "/home/dinesh/apache-root/cgi-bin/playlists/$ip.list";
	print "Saved Successfuly";
}
else{
	my $playlist = retrieve("/home/dinesh/apache-root/cgi-bin/playlists/$ip.list");
	print to_json($playlist);
}

exit;
