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
use URI::Escape;
use Archive::Zip;   # imports

my $q = CGI->new;
my $ip = $ENV{REMOTE_ADDR} || "unknown" ;

my $action = $q->param('action');

if($action eq "save"){
    print "Content-type: text/html\n\n";
    my $data = decode_json($q->param('data'));
	store $data , "/home/dinesh/apache-root/cgi-bin/songs/playlists/$ip.list";
	print "Saved Successfuly";
}
elsif($action eq 'load'){
    print "Content-type: text/html\n\n";
	my $playlist = retrieve("/home/dinesh/apache-root/cgi-bin/songs/playlists/$ip.list");
	print to_json($playlist);
}
elsif($action eq "prepare"){

    my $obj = Archive::Zip->new();   # new instance
    my $data = decode_json($q->param('data'));

    print "Content-type: text/html\n\n";

    foreach my $song (@{$data}) {

        my $file = $song->{mp3};
        my $title = $song->{title};
        (undef, $file) = split('songs/',$file,2);

        $file = '/home/dinesh/Music/Songs/' . $file;

        $file = uri_unescape($file);
        $title = uri_unescape($title);
        $title = $title . ".mp3";

        if( -e $file and -r $file and ( -f $file or -l $file)){
            $obj->addFile($file, $title);   # add files
        }
    }

    if($obj->writeToFileNamed("./temp/$ip.temp.zip") == 0){
        print "Zip created successfully.\n";
    }
}
elsif($action eq 'download'){
    my $filename = "songs_list.zip"; #$q->param('file');
    print "Content-Disposition: attachment;filename=$filename\n";
    print "Content-type: application/zip\n";
    print "\n";

    print download_file("$ip.temp.zip");

    unlink "./temp/$filename";
}
else{
    print "Content-type: text/html\n\n";
    print "Unknown request action $action\n";
}

exit;

sub download_file{
    my $downloadfile = shift;
    my $fullpathdownloadfile = "./temp/$downloadfile";
    my $output = '';
    my $buffer = '';
    open my $fh, '<', $fullpathdownloadfile
        or return error_handler("Error: Failed to download file <b>$downloadfile</b>:<br>$!<br>");

    while (my $bytesread = read($fh, $buffer, 1024)) {
        $output .= $buffer;
    }

    close $fh
        or return error_handler("Error: Failed to download file <b>$downloadfile<b>:<br>$!<br>");

    my  $downloadfilesize = (stat($fullpathdownloadfile))[7]
        or return error_handler("Error: Failed to get file size for <b>$downloadfile<b>:<br>$!<br>");

    return $output;
};

