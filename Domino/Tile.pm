package Tile;

use Moose;
use Moose::Util::TypeConstraints;
use v5.18;

#one side...
has side_a => (
  is  => 'rw',
  isa => 'Int',
  required => 1
);

#... the other side.
has side_b => (
  is  => 'rw',
  isa => 'Int',
  required => 1,
  trigger => sub {my $self = shift; 
    $self->value ($self->side_a + $self->side_b); # The total value of the piece
    $self->draw (" ".$self->side_a  . "|" . $self->side_b." "); # The format of the piece
    $self->is_double($self->side_a eq $self->side_b ? 1 : 0)
    } 
);

has value => (
  is => 'rw',
  isa => 'Int'
);

has draw => (
  is => 'rw'
);

has is_double => (
  is =>'rw',
);

sub rotate {
  my ($self ) = @_;
  my $temp = $self->side_a;
  $self->side_a($self->side_b);
  $self->side_b($temp);
  #$self->draw (" ".$self->side_a  . "|" . $self->side_b." "); # The format of the piece
}

#Test if another piece is a match for this one
sub match_left {
  my ($self, $piece) = @_;
  if  ($piece->side_a eq $self->side_a) {
    $self->rotate;
    return 1;
  } 
  elsif ($piece->side_a eq $self->side_b) {
    return 1;
  }
  return 0; # no match
}

sub match_right {
  my ($self, $piece) = @_;
  if ($piece->side_b eq $self->side_a) {
    return 1;
  }
  elsif ($piece->side_b eq $self->side_b) {
    $self->rotate;
    return 1;
  } #test the other side
  return 0; # no match
}

1;
