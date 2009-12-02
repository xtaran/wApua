# This -*- perl -*- script writes the Makefile for wApua

require 5.004;
use strict;
use ExtUtils::MakeMaker;

sub MY::postamble {
    '
emacs:
	emacs Makefile.PL MANIFEST README CHANGES INSTALL wApua.rc wApua/*.pm bin/wApua bin/*.pl &
';
}

WriteMakefile(
   NAME          => 'wApua',
   VERSION_FROM  => 'bin/wApua',
   EXE_FILES     => [ "bin/wApua", "bin/wbmp2xbm" ],
   PREREQ_PM     => { 'URI'              => "1.03",
                      'URI::Escape'      => undef,
                      'URI::file'        => undef,
                      'URI::Heuristic'   => undef,
                      'LWP'              => "5.47",
                      'LWP::UserAgent'   => undef,
                      'HTML::Parser'     => "2.99_06",
                      'HTML::TokeParser' => undef,
                      'Tk'               => "800.000",
                      'Tk::ROText'       => undef },
   dist          => { COMPRESS => 'gzip -9f',
		      SUFFIX => '.gz' }
);
