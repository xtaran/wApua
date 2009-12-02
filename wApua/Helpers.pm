package wApua::Helpers;

# Copyright (c) 2000, 2006 by Axel Beckert <abe@deuxchevaux.org>
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

#use strict;

# In here are some helpers, needed by wApua (and some of its modules),
# a WAP User Agent, mainly developed for debugging WML pages...

use Exporter ();
@ISA    = qw(Exporter);
@EXPORT = qw(&transformEntities &parsecdata &parseentities &parsespaces &telURL
	     &internalURL &noglobalbind &findINC &preparser &syntaxwarn
	     &syntaxignore &showSource);

use Data::Dumper;
# Idea from Tk::findINC

sub findINC {
    my $file = shift;
    if ($file =~ m(^/)) {
	return $file if (-e $file);
	return undef;
    }
    foreach my $dir (@INC)
    {
	return "$dir/$file" if (-e "$dir/$file");
    }
    return undef;
}

sub noglobalbind { # Keine globalen Key-Bindings für Eingabefelder
    my $f = shift;
    $f->bindtags([$f,ref($f)]);
    $f->bind('<Tab>','focusNext');
    $f->bind('<<LeftTab>>','focusPrev');
    $f->bind('<Shift-Tab>','focusPrev');
}

# Is it an internal URL?
sub internalURL {
    return (shift =~ /^(wapua|about):/i);
}

# Is it an telephone URL?
sub telURL {
    return (shift =~ /^(wtai|tel|fax|modem):/i);
}

sub parsespaces {
    my $seite = shift;
    $seite =~ s/\s+/ /gs;
    $seite =~ s///gs;
    $seite =~ s=\s*(</?(card|p|br|wml|t[dr]|table|head|template|access|meta)(\s[^<>]*)?/?>)((<[^<>]+>)*)\s*=$1$4=gi;
    return $seite;
}

sub parseentities {
    my $seite = shift;
    $seite =~ s/&\#(34|x22);/\&quot;/gi;
    $seite =~ s/&\#(38|x26);/\&amp;/gi;
    $seite =~ s/&\#(39|x27);/\&apos;/gi;
    $seite =~ s/&\#(60|x40);/\&lt;/gi;
    $seite =~ s/&\#(62|x42);/\&gt;/gi;
    $seite =~ s/&\#(160|xA0);/\&nbsp;/gi;
    $seite =~ s/&\#(173|xAD);/\&shy;/gi;

    $seite =~ s/&\#(\d+);/pack("C", $1)/eg;
    $seite =~ s/&\#x([a-fA-F0-9]+);/pack("C", hex($1))/eg;

    return $seite;
}

sub parsecdata {
    my $seite = shift;
    $seite =~ s/&(.*?);/&!$1;/g;

    $seite =~ s/&/&amp;/g;
    $seite =~ s/</&lt;/g;
    $seite =~ s/>/&gt;/g;
    $seite =~ s/\"/&quot;/g;
    $seite =~ s/\'/&apos;/g;
    $seite =~ s/\\\]\\\]/\]\]/g;

    return $seite;
}

sub transformEntities {
    my $seite = shift;

    $seite =~ s/&quot;/\"/g;
    $seite =~ s/&amp;/\&/g;
    $seite =~ s/&apos;/\'/g;
    $seite =~ s/&lt;/</g;
    $seite =~ s/&gt;/>/g;
    $seite =~ s/&nbsp;/ /g;
    $seite =~ s/&shy;/-/g;
    $seite =~ s/&!(.*?);/&$1;/g;

    return $seite;
}

sub preparser {
    my $seite = shift;

    # Delete redundant white spaces
    my $newseite = "";
    while ($seite =~ m=<pre(\s[^<>]+)?>(.*)</pre>|<!CDATA\s+\[\[(.*?)\]\]>=s) {
	my $before = $`;
	my $between;
	if (defined $3) {
	    $between = $3;
	}
	my $match = $&;
	$seite = "$'";

	if ($& =~ /^<pre/) {
	    $newseite .= 
		&parsespaces(&parseentities($before)).
		&parseentities($match);
	} else {
	    $newseite .= (&parsespaces(&parseentities($before)) .
			  "<pre>" .
			  &parsecdata($between) .
			  "</pre>");
	}
    }
    $newseite .= &parsespaces(&parseentities($seite));
    return $newseite;
}

sub syntaxwarn {
    my $expected = shift;
    my $found = shift;
    warn <<EOF;
WML Syntax error: Mismatched closing tag!
    + Expected closing tag: </$expected>
    + Found closing tag: </$found>
EOF
}

sub syntaxignore {
    my $tag = shift;
    if (0 < scalar @_) {
	$tag = shift;
	warn "Ignored unknown tag: <$tag>";
	my %hash = %{shift()};
	foreach (keys %hash) {
	    #warn "  $_: $hash{$_}";
	}
    } else {
	warn "Ignored unknown tag: <$tag>";
    }
}

sub showSource {
    print shift; 
}

1;
