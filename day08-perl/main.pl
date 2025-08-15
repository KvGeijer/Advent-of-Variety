use List::Util qw( max );

# <STDIN> reads one line from stdin

@input = <STDIN>;

for my $line ( @input ) {
    print "\n";

    my @words = split(/ /, $line);

    # For clarity, put each info into a var
    my $reg_mod = $words[0];
    my $op = $words[1];
    my $nbr = int($words[2]);
    my $reg_nbr_cmp = default_get($words[4], %regs, 0);
    my $cmp = $words[5];
    my $nbr_cmp = int($words[6]);

    if (
        $cmp eq ">" && $reg_nbr_cmp > $nbr_cmp
        || $cmp eq "<" && $reg_nbr_cmp < $nbr_cmp
        || $cmp eq ">=" && $reg_nbr_cmp >= $nbr_cmp
        || $cmp eq "<=" && $reg_nbr_cmp <= $nbr_cmp
        || $cmp eq "==" && $reg_nbr_cmp == $nbr_cmp
        || $cmp eq "!=" && $reg_nbr_cmp != $nbr_cmp
    ) {

        if ( $op eq "inc" ) {
            $shift = $nbr;
        } else {
            $shift = -$nbr;
        }

        $regs{$reg_mod} = $shift + default_get($reg_mod, %regs, 0);

        $temp_max = ( $temp_max > $regs{$reg_mod} ) ? $temp_max : $regs{$reg_mod};
    }

}


$final_max = max ( values %regs );
print "The final largest register is $final_max\nThe largest register at any point in time was $temp_max\n";


sub default_get {
    my ( $key, %hash, $default ) = @_;
    if ( exists($hash{$key}) ) {
        return $hash{$key};
    } else {
        return $default;
    }
}
