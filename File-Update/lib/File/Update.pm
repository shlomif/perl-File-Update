package File::Update;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = (qw(modify_on_change write_on_change write_on_change_no_utf8));

sub write_on_change
{
    my ( $io, $text_ref ) = @_;

    if ( ( !-e $io ) or ( $io->slurp_utf8() ne $$text_ref ) )
    {
        $io->spew_utf8($$text_ref);
    }

    return;
}

sub modify_on_change
{
    my ( $io, $sub_ref ) = @_;

    my $text = $io->slurp_utf8();

    if ( $sub_ref->( \$text ) )
    {
        $io->spew_utf8($text);
    }

    return;
}

sub write_on_change_no_utf8
{
    my ( $io, $text_ref ) = @_;

    if ( ( !-e $io ) or ( $io->slurp() ne $$text_ref ) )
    {
        $io->spew($$text_ref);
    }

    return;
}

1;

=head1 NAME

File::Update - update/modify/mutate a file only on change in contents.

=head1 SYNOPSIS

    use Path::Tiny qw/ path /;
    use File::Update qw/ write_on_change /;

    my $text = "Updated on " . strftime("%Y-%m-%d", time) . "\n";

    write_on_change(path("dated-file.txt"), \$text);

=head1 FUNCTIONS

=head2 write_on_change($path, \"new contents")

Accepts a L<Path::Tiny> like object and a reference to a string that contains
the new contents. Writes the new content only if it is different from the
existing one in the file.

=head2 modify_on_change($path, sub { my $t = shift; return $$t =~ s/old/new/g;})

Accepts a subroutine reference that accepts the reference to the existing
content, can mutate it and if it returns a true value, the new text is written
to the file.

=head2 write_on_change_no_utf8($path, \"new contents")

Like write_on_change() but while using L<Path::Tiny>'s non-utf8 methods.

=cut
