package Filter::Comments::C;

use 5.008008;
use strict;
use warnings;
use Filter::Util::Call;

our $VERSION = '0.01';

use constant TRUE => 1;
use constant FALSE => 0;

sub import {
  my $type = @_;
  my %reference = (
    InComment  =>  FALSE,
    File  =>  (caller)[1],
    Line  =>  0,
    Start  =>  0,
  );
  filter_add( bless \%reference );
}
sub die {
  my $self = shift;
  my $note = shift;
  my $line;
  if ( defined $_[0] ) {
    $line = shift;
  } else {
    $line = $self->{Start};
  }
  die( "$note at $self->{File} line $line...\n" );  #  Replace with Carp?
}

sub filter {
  my $self = shift;
  my $status = filter_read();
  ++ $self->{Line};
  
  if ( $status <= 0 ) { # Check for error by EOF
    $self->die( "Comment begin ('/*') has no end ('*/')", $self->{Line} )
      if $self->{InComment};
    return $status;
  }
  if ( $self->{InComment}  ) {
    s/^/#/;
    if ( m/\*\// ) {
      $self->{InComment} = FALSE;
      s/\*\//\n/;
    }
  }
  elsif ( m/\/\*/ ) {
    $self->{InComment} = TRUE;
    $self->{start} = $self->{Line};
    s/\/\*/#/;
  }
  elsif ( m/\*\// ) {
    $self->die( "Orphaned end ('*/')...", $self->{Line} );
  }
  return $status;
}


1;
__END__
# Documentation!

=head1 NAME

Filter::Comments::C - Perl extension to allow programmers to use C-style comments in their Perl code

=head1 SYNOPSIS

  use Filter::Comments::C;

=head1 DESCRIPTION

Allows programmers to use the commenting style of the C programming language; C</*> and C<*/>.  It provides an easy way to comment out or enable debug code.  The delimiters may appear anywhere on a the line.

An example...
B<Without> C<Filter::Comments::C> (I<code block commented out>):

  ## START DEBUG CODE
  #print "Reported Date: $date\n";
  #print "Reported Time: $time\n";
  #open LOG, ">>log.log";
  #print LOG "$date";
  #print LOG ",";
  #print LOG "$time\n";
  ## END   DEBUG CODE

B<With> C<Filter::Comments::C> (I<code block commented out>):

  /* START DEBUG CODE
  print "Reported Date: $date\n";
  print "Reported Time: $time\n";
  open LOG, ">>log.log";
  print LOG "$date";
  print LOG ",";
  print LOG "$time\n";
     END   DEBUG CODE */

=head1 BUGS

=over 4

=item *

This is the first release of this module.  I'm sure it has some kind of bugs.  Bug reports, patches, and test results are most appreciated.  Thanks!

=item *

A start (/*) without an end will result in the entire file being commented out.  This will be fixed in 0.02.

=back

=head1 SUPPORT

All bugs should be filed via the CPAN bug tracker at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Filter-Comments-C>.

For any other issues, suggestions, questions, comments, or support, please contact the author.

=head1 HISTORY

=over 4

=item 0.01

Original version;

=back

=head1 AUTHOR

Matthew J. Kosmoski, E<lt>kosmo@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Matthew J. Kosmoski

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
