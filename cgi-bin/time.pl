#!/usr/bin/perl -w

#
# time.pl
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


print "Content-type: text/html\n\n";

print "<html><head>";
print "<title>Time Now</title>";
print "</head><body>";


print "<h1>".localtime."</h1>";
print "<h3>".$ENV{REMOTE_ADDR}."</h3>";


print "</body></html>";

exit;
