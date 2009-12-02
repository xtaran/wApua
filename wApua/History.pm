package wApua::History;

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

# This is the history object for wApua, a WAP User Agent, mainly
# developed for debugging WML pages...

# constructor

sub new {
    shift;
    my $self	= {};
    $self->{point}  = -1;
    $self->{url}    = [];
    $self->{getabs} = 0;
    $self->{fetch}  = shift;
    $self->{state}  = shift;
    $self->{fwd}    = shift;
    $self->{menu}   = shift;
    $self->{mark}   = shift;
    $self->{oldm}   = ${$self->{menucolors}}{-background};
    $self->{title}  = {};
    %{$self->{menucolors}} = @_;
    bless($self);
    return $self;
}

# history functions

sub push { # pushes URL on history stack. forward stack gets lost.
    my $self = shift;
    while (($self->{point}+1) != scalar @{$self->{url}}) {
	pop @{$self->{url}};
    }
    my $URL = shift;
    my $title = "";
    $title = shift if @_;
    push @{$self->{url}},$URL;
    ${$self->{title}}{$URL}=$title;
    $self->{point} += 1;
    $self->update_menu;
    return $URL;
}

sub size { # get the size of the history
    my $self = shift;
    return scalar @{$self->{url}};
}

sub last { # returns the URL, back would go to, without changing any data
	   # returns 0, if the end of history is reached
    my $self = shift;
    my $id = $self->{point}-1;
    return ($id < 0 ? 0 : $ {$self->{url}}[$id]);
}

sub next { # returns the URL, forward would go to, without changing any data
	   # returns 0, if the end of history is reached
    my $self = shift;
    my $id = $self->{point}+1;
    return ($id >= scalar @{$self->{url}} ? 0 : $ {$self->{url}}[$id]);
}

sub top { # returns the top-most URL, without changing any data
	  # returns 0, if the history is empty
    my $self = shift;
    return ($self->{point} < 0 ? 0 : $ {$self->{url}}[$self->{point}]);
}

sub title { # returns the top-most URL, without changing any data
	    # returns 0, if the history is empty
    my $self = shift;
    my $url = shift;
    return ${$self->{title}}{$url}
	if defined ${$self->{title}}{$url};
}

sub back { # goes backward in history and returns the last URL used.
    my $self = shift;
    my $id = $self->{point}-1;
    if ($id < 0) {
	return 0;
    } else {
	$self->{point} = $id;
	$self->update_menu;
	return  ${$self->{url}}[$id];
    }
}

sub forward { # goes forward
    my $self = shift;
    my $id = $self->{point}+1;
    if ($id >= scalar @{$self->{url}}) {
	return 0;
    } else {
	$self->{point} = $id;
	$self->update_menu;
	return  ${$self->{url}}[$id];
    }
}

sub backwardHistory { # returns all visited pages until the actual
    my $self = shift;
    my $id = 0;
    my @bH = ();
    while ($id < $self->{point}) {
	push @bH,${$self->{url}}[$id++];
    }
    return @bH;
}

sub forwardHistory { # returns all visited pages from the actual
    my $self = shift;
    my $id = $self->{point}+1;
    my @fH = ();
    while ($id < scalar @{$self->{url}}) {
	push @fH,${$self->{url}}[$id++];
    }
    return @fH;
}

sub allHistory { # returns all pages in history
    my $self = shift;
    return @{$self->{url}};
}

sub get { # get the history entry (absolute or relative to the actual),
	  # it returns 0, if the parameter is out of the scope of history
    my $self = shift;
    my $id = ($self->{getabs}?shift:$self->{point}+shift);
    return (($id < 0) || ($id >= scalar @{$self->{url}}) ?
	    0 : $ {$self->{url}}[$id]);
}

sub set { # changes the actual URL (e.g. after some redirect), returns
	  # old URL
    my $self = shift;
    my $old = ${$self->{url}}[$self->{point}];
    ${$self->{url}}[$self->{point}] = shift;
    ${$self->{title}}[$self->{point}] = shift if @_;
    $self->update_menu;
    return $old;
}

sub settitle { # changes the actual title and returns old one
    my $self = shift;
    my $old = ${$self->{title}}{$self->top};
    ${$self->{title}}{$self->top} = shift;
    $self->update_menu;
    return $old;
}

sub absolute { # get or set if get interprets parameters relative
	       # (default) or absolute.
    my $self = shift;
    if (@_) {
	$self->{getabs} = shift;
    }
    return $self->{getabs};
}

sub update_menu {
    my $self = shift;
    $self->{menu}->delete(0,"end");
    my $i = 0;
    my %url;
    foreach ($self->allHistory) {
	my $foo = $_;
	my $bar = $i;
	$ {$self->{menucolors}}{-background} = ($bar == $self->{point} ?
						$self->{mark} : $self->{oldm});
	$url{$bar+1} = $_;
	$self->{menu}->command(-label => ($self->title($_) ?
					  $self->title($_) : $_),
			       %{$self->{menucolors}},
			       -accelerator => $bar+1,
			       -command     => sub {
				   $self->pos($bar);
				   $self->{fwd}->configure(-state => "normal")
				       if $self->next;
				   &{$self->{fetch}}($foo,0);
			       }
			       );
	$i++;
    }
    $self->{menu}->bind('<<MenuSelect>>' => sub {
	my $w = $Tk::event->W;
	if ($self->{menu}->type('active') eq "command") {
	    &{$self->{state}}("Goto ".
			      $url{$w->entrycget('active', -accelerator)});
	} elsif ($self->{menu}->type('active') eq "tearoff") {
	    &{$self->{state}}("Click here to get a tear-off menu");
	} else {
	    &{$self->{state}}("");
	}
	$self->{menu}->idletasks;
    });
}

sub pos { # get or set the actual page id in history
    my $self = shift;
    if (@_) {
	$self->{point} = shift;
    }
    return $self->{point};
}

1;
