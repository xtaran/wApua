package wApua::About;

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

# This is the About-Pages object for wApua, a WAP User Agent, mainly
# developed for debugging WML pages...

use wApua::Helpers;

sub new {
    my $self    = {};
    shift;
    my $version = shift;
    my $cache = shift;
    my $helpkey = (shift).", ?";
    $helpkey .= ", F1" if $helpkey ne "F1";
    my @modkeylist = @_;
    my $LWPversion = $LWP::VERSION;
    my $URIversion = $URI::VERSION;
    my $TokeParserVersion = $HTML::TokeParser::VERSION;
    my $ParserVersion     = $HTML::Parser::VERSION;
    my $TkVersion  = $Tk::VERSION;
    my $date       = localtime($);
    my $imgloc     = "file://".&findINC('wApua/images/wApua.wbmp');
    $self->{about} = <<EOF;
<wml>

<template>
	<do name='prev' type='prev' label='Back'>
		<prev/>
	</do>
	<do name='index' type='index' label='About:'>
		<go href='about:#index'/>
	</do>
</template>

<card id='index' title='About $version'>
	<do name='index' type='index' label='About:'>
		<noop/>
	</do>
<p>

<img src='$imgloc' width='79' height='25' alt='$version'/>

</p><small><p>

$version is a web browser for WML (version 1.1 and 1.2) pages. It is
primarily designed for debugging WML pages in comparsion to only
browsing the WML pages on the web.

</p><p>

+ <a href='about:#keys'>Key Bindings</a><br/>
+ <a href='about:#perl'>About wApua and PERL</a><br/>
+ <a href='about:#name'>About the name wApua</a><br/>
+ <a href='about:#author'>Author of wApua</a><br/>
+ <a href='about:#license'>Copyright -eh- left</a><br/>
+ <a href='about:#download'>Download the latest version</a><br/>
+ <a href='about:#info'>Program Environment</a><br/>
+ <a href='about:#env'>System Environment</a><br/>
+ <a href='about:#libs'>Loaded Perl Libraries</a><br/>
+ <a href='about:#cache'>Cache Contents</a><br/>

</p></small></card><card id='keys' title='About $version: PERL'><p>

<big><u>$version Key Bindings</u></big>

</p><p><u>General Key Bindings</u></p>

<small><table columns='2'>
<tr><td>Tab</td>		   <td>focus next object/window</td></tr>
<tr><td>LeftTab, Shift-Tab</td><td>focus previous object/window</td></tr>

<tr><td>j, Return, CursorDown, Control-N</td>
	<td>scroll one line down</td></tr>
<tr><td>k, Minus, CursorDown, Control-P</td>
	<td>scroll one line up</td></tr>

<tr><td>PageDown, Space</td>	<td>Scroll one page down</td></tr>
<tr><td>PageUp, BackSpace</td>	<td>Scroll one page up</td></tr>

<tr><td>$helpkey</td><td>Opens this page (about:\#keys)</td></tr>
EOF

my $helpwml = "<tr><td>";
$helpwml .= "Alt-F4, Meta-F4, " unless $ eq "MacOS";
$helpwml .= "[%-Q]</td><td>Exit $version</td></tr>\n<tr><td>";
$helpwml .= "Again, L2, " unless $ eq "MSWin32" or $ eq "MacOS";
$helpwml .= "[%-R]</td><td>Reload actual page</td></tr>\n";

$helpwml .= <<EOF;
<tr><td>h, [%-Left], [%-B]</td>	<td>Back in history</td></tr>
<tr><td>l, [%-Right], [%-F]</td><td>Forward in history</td></tr>
<tr><td>[%-H]</td>	<td>Go to home page</td></tr>
<tr><td>[%-U]</td>	<td>Show source code of actual document</td></tr>
EOF

my $commandwml = "";

foreach my $modkey (@modkeylist) {
    $commandwml .= "[$modkey".'-$1]';
}

$commandwml =~ s/\]\[/, /g;
$commandwml =~ s/[][]//g;
$commandwml = '"'.$commandwml.'"';

$helpwml =~ s/\[%-([^][]*)\]/eval($commandwml)/egs;

$self->{about} .= $helpwml;

$self->{about} .= "<tr><td>Props, L3</td><td>Opens the program environment page (<a href='about:#info'>about:\#info</a>)</td></tr>\n"
    unless ($ eq "MSWin32" or $ eq "MacOS");

$self->{about} .= <<EOF;
</table></small>

<p><u>Additional Key Bindings for the Location Field</u></p>

<small><table columns='2'>
<tr><td>Return</td><td>Open URL in location field</td></tr>
<tr><td>Control-U</td><td>Clear location field</td></tr>
</table></small></card><card id='perl' title='About $version: PERL'><p>

<big><u>$version and PERL</u></big>

</p><small><p>

$version requires the following PERL modules, which are not included
in the $version distribution:<br/>

+ LWP::UserAgent (at least libwww-perl Version 5.47)<br/>
+ URI<br/>
+ HTML::TokeParser

</p><p>

The GUI is implemented in perl/Tk.

</p></small></card><card id='name' title='About the name wApua'><p>

<big><u>The Name of the Game: wApua</u></big>

</p><small><p>

The name "wApua" has two meanings:

</p><p>

<u>WAP UA</u> stands for <u>WAP</u> <u>U</u>ser<u>A</u>gent, although
- at the moment - it\'s just an WML browser fetching pages by HTTP.

</p><p>

<u>Apua</u> is Finnish and means 'Help' and this browser initially was
and probably still is nothing else but some help for debugging WML
pages on the web...

</p></small></card><card id='license' title='Copyleft'><p>

<big><u>Copyright -eh- left</u></big>

</p><small><p>

<b>Copyright &#xA9; 2000, 2006, 2009 by
<a href='http://fsinfo.noone.org/~abe/index.wml'>Axel Beckert</a>
<a href='mailto:wapua\@deuxchevaux.org'>&lt;wapua\@deuxchevaux.org&gt;</a></b>

</p><p>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

</p><p>

This program is distributed in the hope that it will be useful, but
<strong>without any warranty</strong>; without even the implied
warranty of <strong>merchantability</strong> or <strong>fitness for a
particular purpose</strong>.  See the GNU General Public License for
more details.

</p><p>

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02111-1301, USA.

</p><p>

You can reach the author by <a href='about:#author'>snail-mail and e-mail</a>.

</p></small></card><card id='author' title='wApua Author'><p>

<big><u>Author of $version</u></big>

</p><small><p>

Axel Beckert<br/>
<table columns='2'><tr>
	<td>Mail:</td>
	<td>Kürbergstrasse 20<br/>
	    8049 Zürich, Switzerland</td>
</tr><tr>
	<td>E-Mail:</td>
	<td><a href='mailto:wapua\@deuxchevaux.org'
		>&lt;wapua\@deuxchevaux.org&gt;</a></td>
</tr><tr>
	<td>WWW:</td>
	<td><a href='http://abe.home.pages.de/english.html'
		>http://abe.home.pages.de/english.html</a></td>
</tr><tr>
	<td>WAP:</td>
	<td><a href='http://fsinfo.noone.org/~abe/index.wml'
		>http://fsinfo.noone.org/~abe/index.wml</a></td>
</tr></table>

</p></small></card><card id='download' title='wApua Download'><p>

<big><u>Downloading $version</u></big>

</p><small><p>

You can download the actual version of wApua at the wApua Home Page.

<table columns='2'><tr>
	<td>WML version</td>
	<td><a href='http://fsinfo.noone.org/~abe/wApua/index.wml'
	    >http://fsinfo.noone.org/~abe/wApua/index.wml</a></td>
</tr><tr>
	<td>HTML version</td>
	<td><a href='http://fsinfo.noone.org/~abe/wApua/index.html'
	    >http://fsinfo.noone.org/~abe/wApua/index.html</a></td>
</tr></table>

</p></small></card><card id='info' title='Program environment'><p>

<big><u>Actual Environment</u></big>

</p><p><small>

<table columns='2'>
<tr><td><b>Program name:</b></td><td>$0</td></tr>
<tr><td><b>Running PERL version:</b></td><td>$] ($)</td></tr>
<tr><td><b>Running libwww-perl version:</b></td><td>$LWPversion</td></tr>
<tr><td><b>Running HTML::Parser version:</b></td><td>$ParserVersion</td></tr>
<tr><td><b>Running HTML::TokeParser version:</b></td><td>$TokeParserVersion</td></tr>
<tr><td><b>Running URI version:</b></td><td>$URIversion</td></tr>
<tr><td><b>Running perl/Tk version:</b></td><td>$TkVersion</td></tr>
<tr><td><b>Process id:</b></td><td>$$</td></tr>
<tr><td><b>OS type:</b></td><td>$</td></tr>
<tr><td><b>Program start:</b></td><td>$date</td></tr>
<tr><td><b>User id:</b></td><td>$< ($>)</td></tr>
<tr><td><b>Group ids:</b></td><td>$( ($))</td></tr>
</table>

</small></p></card><card id='env' title='System environment'><p>

<big><u>System Environment</u></big>

</p><p><small>

<table columns='2'>
EOF

    foreach (sort keys %ENV) {
	$self->{about} .= "<tr><td><b>$_</b></td><td>$ENV{$_}</td></tr>\n";
    }

    $self->{about} .= <<EOF;

</table>
</small></p></card><card id='libs' title='Loaded Perl Libraries'><p>

<big><u>Loaded Perl Libraries</u></big>

</p><p><small>

<table columns='2'>
EOF

    foreach my $m (sort keys %INC) {
	$self->{about} .= "<tr><td>$m</td>	<td>$INC{$m}</td></tr>\n"
	    unless $m =~ m(^/);
    }

    $self->{about} .= <<EOF;

</table>
</small></p></card><card id='cache' title='Cache contents'><p>

<big><u>Cache contents</u></big>

</p><p><small><table columns='3'>
<tr><td><b>URL</b></td><td><b>Last modification</b></td><td><b>Size</b></td></tr>
EOF

    foreach my $url (sort $cache->getURLs()) {
	my $timestring = ($cache->getLastModified($url) ?
			  localtime($cache->getLastModified($url)) :
			  "[Unknown]");
	#print STDERR "CACHE($url): ".$cache->getCachedContent($url)."\n";
	my $sizestring = length($cache->getCachedContent($url));
	$self->{about} .= ("<tr><td>$url</td>".
			   "<td>$timestring</td>".
			   "<td>$sizestring Bytes</td></tr>\n");
    }

    $self->{about} .= <<EOF;
</table>
</small></p></card></wml>

EOF

    bless($self);
    return $self;
}

sub as_string {
    my $self = shift;
    return $self->{about};
}

1;
