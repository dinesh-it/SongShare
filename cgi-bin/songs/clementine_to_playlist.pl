#!/usr/bin/perl

#
# test.pl
#
# Developed by Dinesh D <dinesh@exceleron.com>
# Copyright (c) 2015 Exceleron Software, LLC.
# All rights reserved.
#
# Changelog:
# 2015-07-06 - created
#

use strict;
use warnings;
use JSON;
use XML::Hash;
use Storable;
use Data::Dumper;

my $xml_file = $ARGV[0] || "test.xml";
my $ip = $ARGV[1] || "127.0.0.1";

if(-e $xml_file){

    local $\ = undef;

    open F ,"<$xml_file" or die $!;
    my $xml = <F>;
    close F;

    my $xml_converter = XML::Hash->new();

    # Convertion from a XML String to a Hash
    my $xml_hash = $xml_converter->fromXMLStringtoHash($xml);

    my @songs;

    foreach my $song (@{$xml_hash->{playlist}->{trackList}->{track}}){

        # http://0.0.0.0/songs/Ajith%20hits/Hey%20Nilave%20-%20Mugavari.mp3

        # file:///home/dinesh/Music/Songs/2014/Thegidi/Yaar Ezhudhiyadho.mp3 

        my $path = $song->{location}->{text};
        (undef, $path) = split('/Songs/',$path,2);
        $path = '/songs/' . $path;

        $path =~ s/ /%20/g;

        my $data = {
            mp3 => $path,
            title => $song->{title}->{text},
            artist => 'Unknown',
            album => $song->{album}->{text}
        };

        push (@songs, $data);
    }


    #$xml_hash = playlists('','127.0.0.1');
    if(playlists('save',$ip,\@songs)){
        print "Playlist stored in file $ip.list successfully\n";
    }
    else{
        print "Something went wrong\n";
    }
}
else{
    print "Input file $xml_file not found\n";
}

sub playlists {
    my ($action, $ip, $data) = @_;

    if($action eq "save" and $data){
        store $data , "/home/dinesh/apache-root/cgi-bin/songs/playlists/$ip.list";
        return 1;
    }
    else{
        my $playlist = retrieve("/home/dinesh/apache-root/cgi-bin/songs/playlists/$ip.list");
        return to_json($playlist);
    }
}

