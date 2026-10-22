	use Audio::Beep;
	use File::Slurp;
# Setting up the chanter note pitches
$scale = read_file( 'chanter.txt' );
@notes = split(/['\n'\,]/, $scale);
# Reading in a four count to show the tempo
$four = read_file( 'count.txt' );
# Reading in the Piping tune
$toon = read_file( $ARGV[0] );
# Join the four count and the tune together for playing
$_ = join "", $four, $toon;
# Substituting frequencys for notes
s/g/$notes[0]/g;
s/a/$notes[1]/g;
s/b/$notes[2]/g;
s/c/$notes[3]/g;
s/d/$notes[4]/g;
s/e/$notes[5]/g;
s/f/$notes[6]/g;
s/G/$notes[7]/g;
s/A/$notes[8]/g;
# Turning the data into an easy to use array
@song = split(/['\n'\,]/, $_);
# Getting the last place of the array, this should always be a odd number
# Because the song is a string of pairs a note and the length of time of the note
# and the array begins with 0 not 1 so an even number of items will show an odd last place
$last_index_of_song = $#song;
# Getting the melody multplier, the larger the slower the melody around 12 is good
$melody = $ARGV[1];
# Getting the gracenote time in milliseconds.  Around 30 is a good number
$gracenote = $ARGV[2];
# The starting marker of the song array
$song_run = 0;
# The flag that says if a gracenote has been played.
# Used to take away the time of the gracenotes from the melody note
# that they proceed
$graceflag = 0;
# The beginning of array loop
while($song_run <= $last_index_of_song)
{
$pipe_note = $song[$song_run];
$note_length = $song[$song_run+1];
if ($note_length == 0) {
$note_length = $gracenote;
++$graceflag;
beep($pipe_note,$note_length);
} else {
$note_length = (($note_length * $melody) - ($graceflag * $gracenote));
if ($note_length < 0){
$note_length = 0;
}
beep($pipe_note,$note_length);
$graceflag = 0;
}
++$song_run;
++$song_run;
}