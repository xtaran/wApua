package wApua::Config;

# Copyright (C) 2000, 2006, 2009, 2016 by Axel Beckert <wapua@deuxchevaux.org>
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

# This is the standard configuration of wApua, a WAP User Agent,
# mainly developed for debugging WML pages...

# Edit the values in the function readConfig to change the wApua
# default configuration.

sub new {
    # Builds and returns a configuration hash, based on the values
    # given in this file, the configfile and the command line options.
    my $self = {};
    shift;
    $self->{config} = 0;
    $self->{configfile} = 0;
    bless($self);
    return $self;
}

sub readConfig {
    # Builds and returns a configuration hash, based on the values
    # given in this file, the configfile and the command line options.
    my $self = shift;
    my $configfile = $self->getConfigFile;
    my %CONFIG;

    # Initial configuration

# Proxy configuration only via environment variables at the
# moment. From the LWP::UserAgent man page:

#       $ua->env_proxy()
#           Load proxy settings from *_proxy environment variables.
#           You might specify proxies like this (sh-syntax):

#             gopher_proxy=http://proxy.my.place/
#             wais_proxy=http://proxy.my.place/
#             no_proxy="localhost,my.domain"
#             export gopher_proxy wais_proxy no_proxy

#           Csh or tcsh users should use the setenv command to
#           define these environment variables.

# If you have warnings about some KP keysym (seems to appear under MS
# win and is probably some perl/Tk or Tk problem), set this to 1.
    $CONFIG{NoKPKeySyms} = 0;

# If you like the old text buttons more than the new bitmap ones, say
# here 1 instead of 0.
    $CONFIG{TextButtons} = 0;

# Keys
    $CONFIG{ModKeys} = "Alt Meta Control";
    $CONFIG{ModKeys} = "Alt Control" if ($^O eq "MSWin32");
    $CONFIG{ModKeys} = "Command" if ($^O eq "MacOS");

    $CONFIG{DefaultModKey} = "Meta";
    $CONFIG{DefaultModKey} = "Control" if ($^O eq "MSWin32");
    $CONFIG{DefaultModKey} = "Command" if ($^O eq "MacOS");

    $CONFIG{HelpKey} = "Help";
    $CONFIG{HelpKey} = "F1" if ($^O eq "MSWin32");
    $CONFIG{HelpKey} = "F1" if ($^O eq "MacOS");
	# Anyone knows what keysym some key for help on Macs has?

# Fonts
    $CONFIG{FontFamily} = "helvetica";
    $CONFIG{TTFontFamily} = "courier";
    $CONFIG{SoftButtonFont} = "font=-1=normal";

# Font sizes
    $CONFIG{'FontSize-2'} =  6;
    $CONFIG{'FontSize-1'} =  8;
    $CONFIG{'FontSize0'}  = 10;
    $CONFIG{'FontSize+1'} = 12;
    $CONFIG{'FontSize+2'} = 14;

# Cursors
    $CONFIG{TextCursor} = "xterm"; #xterm (or pencil)
    $CONFIG{WaitCursor} = "watch"; #watch (or trek)
    $CONFIG{NormalCursor} = "top_left_arrow"; #top_left_arrow
    $CONFIG{LinkCursor} = "center_ptr"; #hand2

# All possibilities of X11:
#
# X_cursor, arrow, based_arrow_down, based_arrow_up, boat, bogosity,
# bottom_left_corner, bottom_right_corner, bottom_side, bottom_tee,
# box_spiral, center_ptr, circle, clock, coffee_mug, cross,
# cross_reverse, crosshair, diamond_cross, dot, dotbox, double_arrow,
# draft_large, draft_small, draped_box, exchange, fleur, gobbler,
# gumby, hand1, hand2, heart, icon, iron_cross, left_ptr, left_side,
# left_tee, leftbutton, ll_angle, lr_angle, man, middlebutton, mouse,
# pencil, pirate, plus, question_arrow, right_ptr, right_side,
# right_tee, rightbutton, rtl_logo, sailboat, sb_down_arrow,
# sb_h_double_arrow, sb_left_arrow, sb_right_arrow, sb_up_arrow,
# sb_v_double_arrow, shuttle, sizing, spider, spraycan, star, target,
# tcross, top_left_arrow, top_left_corner, top_right_corner, top_side,
# top_tee, trek, ul_angle, umbrella, ur_angle, watch, xterm

# Buttons
    $CONFIG{BackButton} = "back.wbmp";
    $CONFIG{ForwardButton} = "forward.wbmp";
    $CONFIG{ReloadButton} = "reload.wbmp";
    $CONFIG{HomeButton} = "home.wbmp";
    $CONFIG{StopButton} = "stop.wbmp";
    $CONFIG{LogoButton} = "wApua.wbmp";
    $CONFIG{LogoURL} = "https://fsinfo.noone.org/~abe/wApua/index.wml";
    $CONFIG{ButtonDirectory} = "wApua/images";
	# Use absolute for paths outside @INC;

# Colors, program
    $CONFIG{Background} = '#808080';
    $CONFIG{Foreground} = '#FFFFFF';
    $CONFIG{BorderWidth} = 2;

# Colors, WAP pages
    $CONFIG{WAPBackground} = '#A6C6A6';
    $CONFIG{WAPForeground} = '#000000';

# Colors, links
    $CONFIG{LinkBackground} = '#A6C6A6';
    $CONFIG{LinkForeground} = '#FFFFFF';
    $CONFIG{LinkBorderWidth} = 2;
    $CONFIG{LinkBorderType} = "flat";

# Colors, hover links
    $CONFIG{HoverBackground} = $CONFIG{LinkBackground};
    $CONFIG{HoverForeground} = $CONFIG{LinkForeground};
    $CONFIG{HoverBorderWidth} = 2;
    $CONFIG{HoverBorderType} = "raised";

# Colors, errors
    $CONFIG{ErrorBackground} = '#A6C6A6';
    $CONFIG{ErrorForeground} = '#FF0000';

# Colors, selections
    $CONFIG{ActiveBackground} = '#B0B0B0';
    $CONFIG{ActiveForeground} = '#FFFFFF';
    $CONFIG{ActiveBorderWidth} = 2;

# Start URL and HTTP headers
    $CONFIG{HomeURL} = "https://fsinfo.noone.org/~abe/wApua/index.wml";
    $CONFIG{HTTP_Accept} =
	"text/vnd.wap.wml; q=1.0, text/plain; q=0.5, image/vnd.wap.wbmp; level=0";
    $CONFIG{HTTP_Accept_Image} = "image/vnd.wap.wbmp; level=0";

# Debugging
    my $debug = $CONFIG{Debug} = $self->{debug} || 0;

# Time Out
    $CONFIG{TimeOut} = 15;

# Carriage return after link?
    $CONFIG{CarriageReturnAfterLink} = 0;

# Reading configuration file
    if ($configfile) {
	print STDERR "Reading configuration from $configfile...\n"
	    if $debug >= 1;
	open(CF,$configfile) or die "Can't open $configfile";
	while (<CF>) {
	    next if /^\s*($|\#)/;
	    chomp;
	    my ($key,$value) = split(/:\s+/,$_,2);
	    $key =~ s/(\s+$|^\s+)//g;
	    $value =~ s/(\s+$|^\s+)//g;
	    $value = 0 if $value =~ /^(No|False)$/i;
	    $value = 1 if $value =~ /^(Yes|True)$/i;
	    if ($key =~ /\s/) {
		warn "Wrong syntax, ignoring line $. of $configfile:\n$_\n";
	    } else {
		$CONFIG{$key} = $value;
	    }
	}
	close CF;
    } else {
	print STDERR
	    "No configuration file found. Using default configuration...\n"
	    if $debug >= 1;
    }

    if ($debug >= 1) {
	print STDERR "Using the following configuration:\n";
	foreach (sort keys %CONFIG) {
	    print STDERR "   $_: $CONFIG{$_}\n";
	}
    }

    $self->{config} = %CONFIG;
    return %CONFIG;
}

sub getConfig {
    # Builds and returns a configuration hash, based on the values
    # given in this file, the configfile and the command line options.
    my $self = shift;
    $self->readConfig unless $self->{config};
    return $self->{config};
}

sub getConfigFile {
    # Builds and returns a configuration hash, based on the values
    # given in this file, the configfile and the command line options.
    my $self = shift;
    my @commandline = ();

    while (@ARGV) {
	$_ = shift(@ARGV);
	if ($_ eq "-f") {
	    $self->{configfile} = shift(@ARGV);
	} elsif ($_ eq "-d") {
	    $self->{debug} = shift(@ARGV);
	} elsif (/^--debug=(\d+)$/) {
	    $self->{debug} = $1;
	} elsif (/^(-h|--(help|usage))$/) {
	    print <<EOT;
Usage: $0 [-f configfile] [-d debuglevel|--debug=debuglevel] [starturl]
       $0 (-h|--help|--usage)
EOT
	    exit 0;
	} else {
	    push(@commandline, $_);
	}
    }
    @ARGV = @commandline;

    unless ($self->{configfile}) {
	my @configfiles = ($^O =~ /^(MSWin32|MacOS)$/ ?
			   ($ENV{"HOME"}."/.wApua.rc",
			    $ENV{"HOME"}."/.wApuarc",
			    $ENV{"HOME"}."/.wapua.rc",
			    $ENV{"HOME"}."/.wapuarc",
			    $ENV{"HOME"}."/wApua.rc",
			    $ENV{"HOME"}."/wapua.rc",
			    $ENV{"HOME"}."/wApua.ini",
			    $ENV{"HOME"}."/wapua.ini") :
			   ($ENV{"HOME"}."/.wApua.rc",
			    $ENV{"HOME"}."/.wApuarc",
			    $ENV{"HOME"}."/.wapua.rc",
			    $ENV{"HOME"}."/.wapuarc"));
	foreach my $configfile (@configfiles) {
	    #print STDERR "Testing $configfile... ";
	    if (-e $configfile) {
		$self->{configfile} = $configfile;
		#print STDERR "That's it!\n";
		last;
	    }
	    #print STDERR "No, not the right one...\n";
	}
    }
    return $self->{configfile};
}

1;
