package wApua::Phone;

# Copyright (C) 2000, 2006, 2009 by Axel Beckert <wapua@deuxchevaux.org>
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02111-1301, USA.
#
# You can reach the author by snail-mail at the following address:
#
#  Axel Beckert
#  Kuerbergstrasse 20
#  8049 Zurich, Switzerland

use strict;

# This is the Phone URL decoder object for wApua, a WAP User Agent,
# mainly developed for debugging WML pages...

use URI::Escape;

sub new {
    my $self = {};
    shift;
    my $url = uri_unescape(shift);
    $url =~ s/\#.*$//;
    $self->{page} = <<EOF;
<wml>

<template>
	<do name='prev' type='prev' label='OK'>
		<prev/>
	</do>
</template>

<card id='index' title='$url'>
<p>

<big><u>wApua Phone URL Decoder</u></big>

</p><p>

EOF

    if ($url =~ m%^(wtai://wp/mc;|tel:)(.*)$%) {
	$self->{page} .= "Dialing <b>$2</b> with virtual phone...\n";
    } elsif ($url =~ m%^wtai://wp/ap;(.*);(.*)$%) {
	$self->{page} .= "Added <b>'$2'</b> with number <b>'$1'</b> to virtual phone book...\n";
    } elsif ($url =~ /^fax:(.*)$/) {
	$self->{page} .= "Sending some virtual <b>fax</b> to <b>$1</b>...\n";
    } elsif ($url =~ /^modem:(.*)$/) {
	$self->{page} .= "Trying to establish a virtual <b>modem</b> connection to <b>$1</b>...\n";
    } else {
	$self->{page} .= "Unsupported phone URL: $url...\n";
    }

    $self->{page} .= <<EOF;

</p></card></wml>

EOF

    bless($self);
    return $self;
}

sub as_string {
    my $self = shift;
    return $self->{page};
}

1;
