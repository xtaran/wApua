package wApua::Cache;

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

# This is the RAM cache object for wApua, a WAP User Agent, mainly
# developed for debugging WML pages...

use HTTP::Response;
use HTTP::Request;

# constructor

sub new {
    shift;
    my $self            = {};
    $self->{response}   = {};
    $self->{ua}         = shift;
    $self->{ua_headers} = shift;
    bless($self);
    return $self;
}

# cache functions

sub addResponse { # add page to cache, needs response object as parameter
    my $self = shift;
    my $response = shift;
    $self->{response}{$response->base} = $response;
    return 1; # successfully saved
}

sub getCachedContent { # retrieve page from cache
    my $self = shift;
    my $url = shift;
    return (exists $self->{response}{$url} ?
	    $self->{response}{$url}->content : 0);
}

sub getCachedResponse { # retrieve cached response object from cache
    my $self = shift;
    my $url = shift;
    if (exists $self->{response}{$url}) {
	return $self->{response}{$url};
    } else {
	warn "Asking for response for $url although it is not stored in cache!";
	return 0;
    }
}

sub getLastModified { # get last modification date of cached object
    my $self = shift;
    my $url = shift;
    if (exists $self->{response}{$url}) {
	return $self->{response}{$url}->last_modified;
    } else {
	warn "Asking for the last-modified-date of $url although it is not stored in cache!";
	return 0;
    }
}

sub getContentLength { # get last modification date of cached object
    my $self = shift;
    my $url = shift;
    if (exists $self->{response}{$url}) {
	return $self->{response}{$url}->content_length;
    } else {
	warn "Asking for the content length of $url although it is not stored in cache!";
	return 0;
    }
}

sub inCache { # is the page already cached?
    my $self = shift;
    my $url = shift;
    return exists $self->{response}{$url};
}

sub getURLs { # get the URLs of all pages in the cache
    my $self = shift;
    return keys %{$self->{response}};
}

sub expired { #  is it necessary to retrieve the page (again)?
    my $self = shift;
    my $url = shift;
    my $headers = $self->{ua_headers};
    if (@_) {
	$headers = shift;
    }
    return 0;
#      if (exists $self->{response}{$url}) {
#  	my $request = new HTTP::Request('HEAD', $url, $headers);
#  	print $request->as_string;
#  	my $response = $self->{ua}->request($request);
#  	print $response->as_string;
#  	print "HEAD:  ".($response->last_modified)."\n";
#  	print "Cache: ".($self->{response}{$url}->last_modified)."\n";
#  	if ($response->last_modified > $self->{response}{$url}->last_modified) {
#  	    return 1;
#  	} else {
#  	    return 0;
#  	}
#      } else {
#  	warn "Asking if $url is expired in cache although it is not stored in cache!";
#  	return 1;
#      }
}

sub getContent { # retrieve page
    my $self = shift;
    my $url = shift;
    return $self->getResponse()->content;
}

sub getResponse { # retrieve response
    my $self = shift;
    my $url = shift;
    if ($self->inCache($url) && $self->expired($url)) {
	return getCachedResponse($url);
    } else {
	my $request = new HTTP::Request('GET', $url, $self->{ua_headers});
	print $request->as_string;
	my $response = $self->{ua}->request($request);
	print $response->as_string;
	return $response;
    }
}

return 1;
