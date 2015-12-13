package Game;

use strict;
use Data::Dumper;
use Moose;
use Moose::Util::TypeConstraints;
use v5.18;
use Tile;

# The number of players that will play the game
has 'num_players' => (
  is   => 'rw',
  isa => 'Int',
  required => '1'
);


sub start {
  my ($self) = @_;
  
# # # #   print "Lets start a new game\n";
  print "Opening the box and getting the pieces... all 28 of them!\n";
  my @table;
  for my $side_a (0..6) {
    for my $side_b (0..$side_a) {
      push @table,  Tile->new('side_a' => $side_a, 'side_b' => $side_b);
    }
  }
  my @play_order;
  $self->{play_order} = \@play_order;
  my $player = '1';
  for my $player (1 .. $self->num_players) {
     $self->{player}{$player}{tiles} = undef;
     $self->{player}{$player}{total} = 0;
     $player++;
   }
  $self->{Table} = \@table;
  $self->{PlayedTiles} = [];
  #Get the player tiles..
  $self->get_players_tiles;
  
  $self->start_game;
  
}

sub get_players_tiles {
  my $self = shift;
  print "Drawing the tiles for the players....\n";
  foreach my $player (keys %{$self->{player}}) {
    my $tiles = $self->_drawn_tiles(7);
    $self->{player}{$player}{tiles} = $tiles;
    print "Player $player hand : ";
    foreach my $tile (@$tiles) {
       print $tile->draw; 
    }
    print "\n";
  }
}

sub _drawn_tiles {
  my ($self,$amount) = @_;
  $amount = 1 if !$amount;
  my $total = scalar(@{ $self->{Table}});#pieces on the table
  my @hand = ();
  my @table = @{ $self->{Table}};
  for my $number (1..$amount) { # the number of tiles to be drawn
    my $pos = int(rand($total)-$number);
	if (scalar @table > 1) {
        push @hand, splice (@table,$pos,1);
	} 
	else {
		push @hand, @table;
		@table = ();
	}  
  }
  $self->{Table} = \@table;
  return \@hand;
}

sub start_game {
  my $self = shift;
  #Fight!!!
  #first piece
  $self->play_bigger_double;
  #The rest of the game...
  my $players = 2;
  while ($players)  {
    $self->play_tiles;
    $players = scalar @{$self->{play_order}};
  }
  ## No more moves, lets get the score..
  my $total;
  my $winner;
  my $draw = 0;
  foreach my $player (keys %{$self->{player}}) {
    my $tiles = $self->{player}{$player}{tiles};
    foreach my $tile (@$tiles) {
      $self->{player}{$player}{total} += $tile->value;
    }
    if ( $self->{player}{$player}{total} == 0 ) {#played all the pieces
      if (defined $total and $total eq '0') {#if the other also scored 0
        $draw = 1;
      }
      $winner = $player;
      $total = 0;
    }
    elsif (!defined $total or $total > $self->{player}{$player}{total}) {
      $total = $self->{player}{$player}{total};
      $winner = $player;
      $draw = 0;
    }
    print "Player $player remaining pips: ", $self->{player}{$player}{total}, "\n";
  }
  print "And the winner is $winner!\n" if !$draw;
  print "Its a draw!!!\n" if $draw;
}

sub play_tiles {
  my $self = shift;
  my $player = shift @{$self->{play_order}};
  my @played = @{$self->{PlayedTiles}};
  my $first = $played[0];
  my $last = $played[-1];
  my @hand = @{$self->{player}{$player}{tiles}};
  my $value = 0;
  my $tile_pos = 0;
  my $play_position;
  my $pos = 0;

  foreach my $tile (@hand) {
    if ($value <= $tile->value) {
        if ($tile->match_left($first)) {
          $value = $tile->value;
          $play_position = 'left';
          $pos = $tile_pos;
        }
        elsif ($tile->match_right($last)) {
          $value = $tile->value;
          $play_position = 'right';
          $pos = $tile_pos;
        }
    }
    $tile_pos ++;
  }
  if ($play_position) { # if there is a place to put it...
    $self->_play_tile($player, $pos, $play_position) if $play_position;
    if ( scalar @{$self->{player}{$player}{tiles}}) {
      push @{$self->{play_order}}, $player ; #if the player still has tiles, continue
    }
    else {
      shift @{$self->{play_order}};# force a end game...
    }
  }
  else {
    if (scalar(@{ $self->{Table}})) {#if the table still has tiles...
      push @{$self->{player}{$player}{tiles}}, @{$self->_drawn_tiles};
      push @{$self->{play_order}}, $player if scalar @{$self->{player}{$player}{tiles}}; #if the player still has tiles, continue
    }
    else {
      #next player
    }
  }
  
}


sub play_bigger_double {
  my $self = shift;
   my $sel_player;
   my $tile_value = 0;
   my $tile_pos;
   foreach my $player (keys %{$self->{player}}) {
     my $pos = 0;
     foreach my $tile ( @{$self->{player}{$player}{tiles}}) {
       if ($tile->is_double and ($tile->value >= $tile_value)) {
         $sel_player  = $player;
         $tile_pos = $pos;
         $tile_value = $tile->value ;
       }
       $pos++;
     }  
  }
  print "First Player : $sel_player\n";
  $self->_drawn_tiles if !$sel_player; #if theres no double, reshufle
  $self->_play_tile($sel_player, $tile_pos);
   foreach my $player (keys %{$self->{player}}) {
      push @{$self->{play_order}}, $player if $player != $sel_player;
    }
    push @{$self->{play_order}}, $sel_player;
}

sub _play_tile {
   my ($self, $player, $tile_pos, $play_position) = @_;
   my $played = $self->{PlayedTiles};#played tiles
    my $tile = ${$self->{player}{$player}{tiles}}[$tile_pos];#where is the played tile
    splice (@{$self->{player}{$player}{tiles}},$tile_pos,1); #shorten the hand
    if (!$play_position) { # First tile
      push @$played, $tile;# push to played
    }
    else {
      if ($play_position eq 'left') {
        unshift @$played, $tile;# push to the left
      }
      else {
        push @$played, $tile;# push to the right
      }
    }

    $self->{PlayedTiles} = \@$played;
    print $_->draw foreach  (@$played);
    print "\n";
}



1;
