#! /usr/bin/perl

use Modern::Perl '2013';
use Email::Valid;

# Script to create a table with the most popular domains 

# Lets see if anything was passed initially

my $table = {};
my @args = @ARGV;

foreach my $email (@args) {
  $table = _ChangeTable($table, $email) if $email;  
}

_PrintTable($table) if keys %{$table};

while (<STDIN>) {
  chomp $_;
  $table = _ChangeTable($table, $_) if $_;
  _PrintTable($table) if keys %{$table};
}


sub _ChangeTable {
  my ($table, $email) = @_;
  # Lets see if its a valid email
  my $valid = Email::Valid->address($email);
  if ($valid) {
    # spliting and increasing the count if exists
    my ($name, $domain) = split (/\@/, $email);
    if (defined $table->{$domain}) {
      $table->{$domain}++;
    }
    else {
      $table->{$domain} = 1;
    }
  }
  return $table;
}

sub _PrintTable {
  my ($table) = @_;
  say '*' x '30';
  say '** Domain ** Popularity ** ';
  my $count = 0;
  foreach my $key (sort { $table->{$b} <=> $table->{$a} } keys %$table) {
    say "** $key ** ", $table->{$key};
    $count ++;
    # Lets limit the count to 10
    last if $count == 10;
  }
  say '*' x '30';
}


