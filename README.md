wApua WML Browser
=================

What is wApua?
--------------

wApua is a
[Wireless Markup Language (WML)](https://en.wikipedia.org/wiki/Wireless_Markup_Language)
browser which can access WML pages via HTTP, HTTPS or locally on the
disk.

It is not able to access content over the
[Wireless Application Protocol (WAP)](https://en.wikipedia.org/wiki/Wireless_Application_Protocol)
for which WML was designed. But the primary purpose of wApua is not to
be used on mobile phones but on Unix or Linux workstations to debug
WAP WML pages without having to use a mobile phone or a potentially
expensive mobile data connection.

wApua is written in the Perl programming language and uses
[libwww-perl](https://github.com/libwww-perl/libwww-perl) and
[Perl/Tk](http://www.perltk.org/).

For installation see the file `INSTALL`.


History
-------

wApua was developed because of frustration about commercial WML
browsers (WinWAP et al), that didn't fit my requirements. In addition
to that, none of them was able to run under diverse Unices, especially
SunOS and Solaris, which were used as work-stations and servers at
university.

And those online WML to HTML converters are slow and not very useful
for debugging WML pages.

So on some day in spring 2000 I thought about writing a WML browser in
Tcl/Tk because some of my colleagues used that for simple-to-write
graphical user interfaces. But I haven't seen any Tcl code before,
because I wrote most of those simple-to-write things in the Perl
programming langauge. Then I discovered Perl/Tk and only a few days
later the first usable verison of wApua was ready for debugging
http://wap.dagstuhl.de/, which was part of my student's job back then
:-).

I worked with wApua for about three or four months. Then someone asked
at the [Heise WAP Forum][1] for a WAP WML browser for Linux and I set
up [a little website][2] with some information and download
possiblities, and [announced it on Freshmeat][3] (now named Freecode
and dead).


Features and Standards Support
------------------------------

wApua doesn't interpret all WML tags yet (e.g. no forms support),
but it especially interprets some tags that WinWAP 2.2/2.3 interprets
very rudimentary or even wrong, e.g. tables and the <noop/>
tag.

Given that WAP is more dead than
[Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) and the
wApua release intervals so far ranged from a few days to five years,
the chances are very low that I'll ever add additional features.


Configuration
-------------

wApua supports configuration via a configuration file `~/.wApua.rc`.

See the source code of `wApua/Config.pm` for configuration
possibilities (colors, fonts, home page, paths, etc.). Every hash-key
used there, can also be used in you configuration file `~/.wApua.rc`. In
addition to that, every key (in the configuration file and `Config.pm`)
beginning with `HTTP_` is treated as HTTP header, which will be added
to every request, that wApua makes. (There is one exception:
`HTTP_Accept_Images` is the HTTP Accept header for retrieving
images). See the file `wApua.rc` for examples and an alternative
coloring scheme.


Starting wApua
--------------

* If you start `wApua` without any options, wApua will start with the
  home page configured in `Config.pm` or `.wApua.rc`.

* Starting wApua with `wApua -f <config-file>` will start wApua and
  read the configuration from `<config-file>`. If you want to suppress
  the reading of .wApua.rc, start wApua with `wApua -f /dev/null`.
  You may also start wApua with `wApua -f -` and it will read the
  configuration from `STDIN`.

* Any other command line parameter will be regarded as (more or
  less) complete URL. If it's the name of an existing file, it will
  be loaded, otherwise wApua will look up if it's a hostname and
  after that being unsuccessful it will try to add some `www.` in
  front and some `.com` at the end...  (Most heuristics done by
  `URI::Heuristics`.)


Download
--------

The latest versions and much more information about wApua can be found
at the [wApua Home Page][2] and at [Freshmeat][3].

You may also try [wApua's WAP WML page][4] with some WML
browser... :-)


Copyright, License and Author
-----------------------------

wApua is copyright 2001-2017 by Axel Beckert <wapua@deuxchevaux.org>
and licensed under the
[GNU General Public License](https://www.gnu.org/licenses/gpl) as
published by the [Free Software Foundation](https://www.fsf.org/),
either [version 2](https://www.gnu.org/licenses/old-licenses/gpl-2.0)
or (at your option) any later version.

[1]: https://web.archive.org/web/20010605003852/http://www.heise.de:80/ix/forum/go.shtml?list=1&g=952686372_61
     (German only)
[2]: https://fsinfo.noone.org/~abe/wApua/
[3]: http://freshmeat.net/projects/wapua/
[4]: https://fsinfo.noone.org/~abe/wApua/index.wml
