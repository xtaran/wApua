package wApua::WBMP2XBM;

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

# This is a perl module, which converts some wireless bitmap (wbmp)
# into some X11 bitmap (xbm). It is mainly designed for use in the
# perl/Tk WAP browser wApua. See wbmp2xbm.pl for some simple example,
# how to use this module.

use strict;

### constructor

sub new {
    shift;
    my $self	     = {};
    $self->{wbmp_string} = shift;
    $self->{image_name}  = (@_ ? shift : "WBMPtoXBM");
    $self->{width}       = 0;
    $self->{height}      = 0;
    $self->{length}      = length($self->{wbmp_string});
    $self->{xbm_string}  = 0;
    $self->{config}      ||= {};
    $self->{config}{debug} = shift || 0;
    bless($self);
    return $self;
}

### Methods

sub xbm { # get the xbm equivalent of the given wbmp image
    my $self = shift;
    $self->convert unless $self->{xbm_string};
    return $self->{xbm_string};
}

sub width { # get the width of the given image
    my $self = shift;
    $self->convert unless $self->{xbm_string};
    return $self->{width};
}

sub height { # get the height of the given image
    my $self = shift;
    $self->convert unless $self->{xbm_string};
    return $self->{height};
}

sub dimension { # get the width of the given image
    my $self = shift;
    $self->convert unless $self->{xbm_string};
    return $self->{width}."×".$self->{height};
}

sub convert { # the converter itself, returns 0 if an error occured
    my $self = shift;
    my $debug = $self->{config}{debug};
    my $wbmp = $self->{wbmp_string};
    if (length $wbmp) {
	my ($data, $rest) = &nextdata($wbmp); $wbmp = $rest;
	print STDERR "WBMP Type: $data" if $debug >= 1;
	if ($data != 0) {
	    warn "\nUnsupported WBMP type";
	    return 0;
	}
	print STDERR " -- OK.\n" if $debug >= 1;
	($data, $rest) = &nextdata($wbmp); $wbmp = $rest;
	print STDERR "WBMP FixHeader: $data" if $debug >= 1;
	if ($data != 0) {
	    warn "\nUnsupported or wrong WBMP type (Extended headers are unsupported.)";
	    return 0;
	}
	print STDERR " -- OK.\n" if $debug >= 1;
	($data, $rest) = &nextdata($wbmp); $wbmp = $rest;
	my $width = $data;
	($data, $rest) = &nextdata($wbmp); $wbmp = $rest;
	my $height = $data;
	$self->{width} = $width;
	$self->{height} = $height;
	my $woctets = ($width >> 3) + (($width % 8)?1:0);
	my $octetrest = $width%8;
	$octetrest = ($octetrest==0?8:$octetrest);
	print STDERR "Image dimension: ${width}x$height ($woctets octets per row)\n"
	    if $debug >= 1;

	$self->{xbm_string} =
	    ("#define ".$self->{image_name}."_width $width\n".
	     "#define ".$self->{image_name}."_height $height\n".
	     "static char ".$self->{image_name}."_bits[] = {\n ");

	my $xbmcol = 0;
	my $col = 0;
	while (length($wbmp) > 0) {
	    $xbmcol++;
	    $col++;
	    $data = ord(substr($wbmp,0,1));
	    $wbmp = substr($wbmp,1);
	    $self->{xbm_string} .= sprintf(" 0x%.2x,",&little_big($data)^0xff);
	    if ($xbmcol > 11) {
		$self->{xbm_string} .=  " \n ";
		$xbmcol = 0;
	    }
	}
	$self->{xbm_string} .=  " };\n";
	return $self->{xbm_string};
    } else {
	return 0;
    }
}

### Subroutines

sub little_big { # converts little endian 8bit integers into big
		 # endian ones (and vice versa of course ;-)
    my $in = shift;
    my $out = 0;
    my $i;
    foreach $i (0..7) {
	if (($in & (1<<(7-$i))) == (1<<(7-$i))) {
	    $out += (1<<$i) ;
	    #print "|";
	} else {
	    #print "-";
	}
    }
    #print "\n";
    return $out;
}

sub header { # reads one byte of some multibyte integer according to WAE
    my $char = shift;
    die "Not very well programmed" if length($char) != 1;
    my ($value,$cont);
    $value = (ord($char) & 127);# << 1;
    $cont = ((ord($char) & 128) == 128)?1:0;
    return ($value,$cont);
}

sub nextdata { # returns the next multibyte integer of the given
	       # string and the rest of the string
   my $string = shift;
    my $cont = 1;
    my $value;
    my $data = 0;
    while ($cont) {
	my $char = substr($string,0,1);
	$string = substr($string,1);
	($value,$cont) = &header($char);
	$data += $value;
	#print "Value: $value; Cont: $cont\n";
    }
    return ($data, $string)
}

1;
