package Base35::From;

use Moose;

use v5.18;

#Lets make sure we have the number as an attribute
has 'number' => (is => 'rw', isa => 'Str', required => '1');
has 'struct' => (is => 'ro', lazy => 1, builder => '_CreateHash');

sub Convert {
  my ($self) = @_;
  my $final = 0;
  my $corres = $self->struct;
  my @array = split(//, $self->number);
  my $pos = 0;
  my $result = 0;
  foreach my $i (reverse @array) { 
    $final += $self->_Multiply($corres->{$i}, $pos);
    $pos++;
  }
  #Now we add the last digit
  $final += $corres->{$array[-1]};
  return $final;
}

sub _Multiply {
  my ($self, $number, $pos) = @_;
  # The number in decimal
  my $converted = $number;
  #We need to multiply by 35 the number of times necessary
  for (1..$pos) {
    $converted = $converted * 35;
  }
  return ($converted );
}


sub _CreateHash {
  my ($self) = @_;
  my %corres;
  map { $corres{$_} = $_} (0..9);
  map { $corres{$_} = keys {%corres}} ('A'..'Y');
  return \%corres;
}

1;

