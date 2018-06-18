#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2;
use Path::Tiny qw/ path /;
use File::Update qw/ write_on_change /;

{
    my $dir = Path::Tiny->tempdir;
    my $f   = $dir->child("test-write_on_change-1.txt");

    write_on_change( $f, \"first text" );

    # TEST
    is_deeply( [ $f->slurp_utf8 ], ["first text"], "initial text" );

    my $mtime = $f->stat->mtime;

    sleep(1);

    write_on_change( $f, \"first text" );

    # TEST
    is( $f->stat->mtime, $mtime, "mtime did not change" );
}
