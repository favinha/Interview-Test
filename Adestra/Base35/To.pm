package Base35::To;

use Moose;
use Data::Dumper;
use v5.18;

#Lets make sure we have the number as an attribute
has 'number' => (is => 'rw', isa => 'Int', required => '1');
has 'struct' => (is => 'ro', lazy => 1, builder => '_CreateHash');

sub Convert {
  my ($self) = @_;
  say "converting ", $self->number;
  my $final = '';
  my $corres = $self->struct;
  my ($quant, $rem) = $self->_Divide($self->number);
  $final = $corres->{$rem}; 
  while ($quant > 34) {
     ($quant, $rem) = $self->_Divide($quant);
     $final = $corres->{$rem} . $final; 
  }
  #Converting the last digit
  $final = $corres->{$quant} . $final; 
  return $final;
}

sub _Divide {
  my ($self, $number) = @_;
  my ($quant, $rem) = (int $number / 35, $number % 35);
  return ($quant, $rem);
}

sub _CreateHash {
  my ($self) = @_;
  my %corres;
  map { $corres{$_} = $_} (0..9);
  map { $corres{$_} = keys {%corres}} ('A'..'Y');
  %corres = reverse(%corres);
  return \%corres;
}


1;

