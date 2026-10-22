	use File::Slurp;
$_ = read_file( $ARGV[0] );
@song = split(/['\n'\,]/, $_);
$last_index_of_song = $#song;
$song_run = 0;
$song_length = 0;
while($song_run <= $last_index_of_song)
{
$note_length = $song[$song_run+1];
$song_length = $song_length + $note_length;
++$song_run;
++$song_run;
}
print "$song_length\n"