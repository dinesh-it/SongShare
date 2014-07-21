#!/usr/bin/perl -w

#
# audios_list.pl
#
# Developed by Dinesh D <dinesh@exceleron.com>
# Copyright (c) 2014 Exceleron Inc
# Licensed under terms of GNU General Public License.
# All rights reserved.
#
# Changelog:
# 2014-06-29 - created
#

use strict;
use MP3::Tag;
use File::Find;
use Data::Dumper;
use Fcntl;


my $audio_list = {};

my @dirs;
if($#ARGV != 0){
@dirs = ("Ajith hits","Arjun hits","A R Rahman","collections","Dilip Varman",
	"Film Wise","Hariharan hangama","Ilayaraja Hits","Kamal hits","Latest","Melodious Love Songs",
	"OLd Melodious","Prabudheva Hits","P Suseela","Rajini Hits","Spb Chitra","Spb Janaki",
	"Surya Hits","Tamil Songs","un organized","Vijay Hits","Yuvan_hits","Yuvan melodious","Yuvan voice");
}
else{ 
	@dirs = (@ARGV); 
}

foreach my $folder (@dirs){

print "Processing $folder\n";
my $dir = "/home/dinesh/Music/Songs/$folder";
$folder =~ s/\s+/_/gm;
open F, ">../view/songs_list/$folder.list";
print F " { \"data\" : [\n";

find({ wanted => \&process_audio_file, no_chdir => 1 }, $dir);

seek F , -2 , 1;
print F "\n] }\n";

close F;

}

my %special_chars = (
	'/' => '\/',
	'"' => '\"',
	' \+' => ' ',
);

sub process_audio_file {
	my $file = $_;
	if( $file and -f $file and $file =~ m/\.mp3$/i ){
		my $mp3 = MP3::Tag->new($file); 
		my ($title, $track, $artist, $album, $comment, $year, $genre) = $mp3->autoinfo();
		#$title = "unknown" if(!$title || $title =~ /^\s*$/ );
		$artist = "unknown" if(!$artist || $artist =~ /^\s*$/ );
		$album = "unknown" if(!$album || $album =~ /^\s*$/ );
		#$audio_list->{$artist}->{$album}->{$title} = $file;
		#$title =~ s/(\/|")/$special_chars{$1}/gme;
		$file =~ m/.+\/(.+)\.mp3/i;
		$title = $1;
		$artist =~ s/(\/|")/$special_chars{$1}/gme if($special_chars{$1});
		$album =~ s/(\/|")/$special_chars{$1}/gme if($special_chars{$1});
		$title =~ s/^(\s+)|[^A-Z0-9:\s\.-_]+//ig;
		$artist =~ s/^(\s+)|[^A-Z0-9:\s\.-_]+//ig;
		$album =~ s/^(\s+)|[^A-Z0-9:\s\.-_]+//ig;
		$file =~ s/"|'//g;
		$file =~ s/^\/home\/dinesh\/Music\/Songs/\/songs/g;
		$file =~ s/\//\\\//g;
		print F "[ \"$artist\", \"$album\", \"$title\", \"$file\" ],\n";
	}
}


#print "Total artists ".scalar( keys(%$audio_list)). "\n";
