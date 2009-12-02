package wApua::UserAgent;

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

@ISA = qw(LWP::UserAgent);

use strict;

# This is just a specialization of LWP::UserAgent for wApua, a WAP
# User Agent, mainly developed for debugging WML pages...

use LWP::UserAgent;
use LWP::MediaTypes qw(add_type);
use Tk::DialogBox;

sub new {
    my $self = new LWP::UserAgent;
    shift;
    # I hate OS names written all in lower case... *g*
    my$os=($=~/[A-Z]/?$:"\u$");
    $os="SunOS" if $os=~/^sunos$/i;
    $os=~s/^(.*)bsd$/\u$ {1}BSD/i;
    $self->agent(shift()." (PERL/$]; lwp/".$LWP::VERSION."; ".
		 "pTk/".$Tk::VERSION."; $os)");
    $self->parse_head(0);
    $self->env_proxy();
    add_type("text/vnd.wap.wml" => qw(wml));
    bless($self);
    return $self;
}

# In the style of lwp-request

sub get_basic_credentials
{
    my($self, $realm, $url) = @_;
    my $host = $url->host_port;
    my($user, $password) = &wApua::PasswordDialog($realm, $host);
    return (undef, undef) unless length $user;
    return ($user, $password);
}


1;
