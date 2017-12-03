wApua README
============

About wApua
-----------

wApua is PERL written WAP WML browser based on libwww-perl and
perl/Tk. For installation see the file INSTALL.

wApua was developed because of frustration about commercial WML
browsers (WinWAP et al), that didn't fit my requirements. In addition
to that, none of them was able to run under diverse Unices, especially
SunOS and Solaris, which we have here on our work-stations. And those
online WML to HTML converters are slow and not very useful for
debugging WML pages. So on some day in spring 2000 I thought about
writing a WML in Tcl/Tk, because some of my colleagues used that for
simple-to-write graphical user interfaces. But I haven't seen any Tcl
code before, because I wrote most of those simple-to-write things in
PERL. Then I discovered Perl/Tk and only a few days later the first
usable verison of wApua was ready for debugging
http://wap.dagstuhl.de/, which is part of my job :-).

I worked with wApua for about three or four months. Then [someone asked
at the Heise WAP Forum][1] for WAP WML browser for Linux and I set up
[a little page][2] with some informations and download possiblities and
[announced it on Freshmeat][3].

It doesn't interpret all WML tags yet (e.g. no forms support yet), but
especially it interprets some tags that WinWAP 2.2/2.3 interprets very
rudimentary or even wrong, e.g. tables and the <noop/> tag. Newest
additions are configuration via configuration file ~/.wApua.rc, a RAM
cache and navigation buttons with images instead of text. There are
still new wApua features in my mind, so watch out for new versions,
which probably come out in quite irregular intervals, which currently
ranged from a few days to five years. ;-)

Hmmm, if there ever will be a final version of wApua? ;-)

See the source code of wApua/Config.pm for configuration possibilities
(colors, fonts, home page, paths, etc.). Every hash-key used there,
can also be used in you configuration file ~/.wApua.rc. In addition to
that, every key (in the configuration file and Config.pm) beginning
with `HTTP_` is treated as HTTP header, which will be added to every
request, that wApua makes. (There is one exception: HTTP_Accept_Images
is the HTTP Accept header for retrieving images). See the file
wApua.rc for examples and an alternative coloring scheme.

Starting wApua
--------------

* If you start wApua without any options, wApua will start with the
  home page configured in Config.pm or .wApua.rc.

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

The latest versions and much more information about wApua can be found
at the [wApua Home Page][2] and at [Freshmeat][3].

You may also try [wApua's WAP WML page][4] with some WAP
browser... :-)

You can reach the author of wApua (Axel Beckert, that's me :-) via
e-mail at wapua@deuxchevaux.org. Bug reports and suggestions are
welcome.

Hope, you find it useful.

Have fun! Axel.


[1]: http://www.heise.de/ix/forum/go.shtml?list=1&g=952686372_61
     (German only)
[2]: http://fsinfo.noone.org/~abe/wApua/
[3]: http://freshmeat.net/projects/wapua/
[4]: http://fsinfo.noone.org/~abe/wApua/index.wml
