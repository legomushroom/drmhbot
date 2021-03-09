use v6;

use DB::Pg;

=begin pod

=head1 C<edit-sources>

Use this script to edit the sources table.

=head2 Usage

=head3 Setting the C<DATABASE_URL> environment variable

In Fish, you can do this using a command like:

=begin code
set DATABASE_URL (heroku config:get DATABASE_URL -a drmh)
=end code

=head3 Adding a new source

=begin code
raku edit-sources.raku --database $DATABASE_URL --name "Example Source" --hostname "www.example.com"
=end code

=head3 Removing a source

You can only remove a source by hostname.

=begin code
raku edit-sources.raku --database $DATABASE_URL --hostname "www.example.com"
=end code

=head2 Dependencies

=item DB::Pg

=end pod

multi sub MAIN(Str :database($database-url)!, Str :$name!, Str :$hostname!) {
    my $conn = DB::Pg.new(:conninfo<$database-url>);

    $conn.query("INSERT INTO sources VALUES ($1, $2)", $name, $hostname);
}

multi sub MAIN(Str :database($database-url)!, Str :$hostname!) {
    my $conn = DB::Pg.new(:conninfo<$database-url>);

    $conn.query("DELETE FROM sources WHERE hostname = $1", $hostname);
}
