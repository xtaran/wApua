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
                      'URI::Escape'      => 0,
                      'URI::file'        => 0,
                      'URI::Heuristic'   => 0,
                      'LWP'              => "5.47",
                      'LWP::UserAgent'   => 0,
                      'HTML::Parser'     => "2.99_06",
                      'HTML::TokeParser' => 0,
                      'Tk'               => "800.000",
                      'Tk::ROText'       => 0 },
   dist          => { COMPRESS => 'gzip -9f',
		      SUFFIX => '.gz' }
);
