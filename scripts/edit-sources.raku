use v6;

use DB::Pg;

multi sub MAIN(Str :database($database-url)!, Str :$name!, Str :$hostname!) {
    my $conn = DB::Pg.new(:conninfo<$database-url>);

    $conn.query("INSERT INTO sources VALUES ($1, $2)", $name, $hostname);
}

multi sub MAIN(Str :database($database-url)!, Str :$hostname!) {
    my $conn = DB::Pg.new(:conninfo<$database-url>);

    $conn.query("DELETE FROM sources WHERE hostname = $1", $hostname);
}
