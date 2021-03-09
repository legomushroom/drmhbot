use v6;

=begin pod

=head1 C<edit-sources>

Use this script to edit the sources table.

=head2 Usage

=head3 Setting the C<DATABASE_URL> environment variable

Before running the script, the environment variable C<DATABASE_URL> needs to
be set. In Fish, you can do this using a command like:

=code set -x DATABASE_URL (heroku config:get DATABASE_URL -a drmh)

=head3 Adding a new source

=code raku scripts/edit-sources.raku --name="Example Source" --hostname="www.example.com"

=head3 Removing a source

You can only remove a source by hostname.

=code raku scripts/edit-sources.raku --hostname="www.example.com"

=head2 Dependencies

=item L<C<DB::Pg>|https://github.com/CurtTilmes/raku-dbpg>

=end pod

use DB::Pg;

my constant $database-url = %*ENV<DATABASE_URL>
    or die 'Please set the $DATABASE_URL environment variable (see docs).';

#| Open the "List sources" dataclip in a browser.
multi sub MAIN() {
    my constant $list-sources-url =
        "https://data.heroku.com/dataclips/imyepakolrfaqwkidvmznoyednwd";

    run("open", $list-sources-url);
}

#| Add a new source.
multi sub MAIN(Str :$name!, Str :$hostname!) {
    my $conn = DB::Pg.new(conninfo => $database-url);

    $conn.query('INSERT INTO sources VALUES ($1, $2)', $name, $hostname);
}

#| Remove a source.
multi sub MAIN(Str :$hostname!) {
    my $conn = DB::Pg.new(conninfo => $database-url);

    $conn.query('DELETE FROM sources WHERE hostname = $1', $hostname);
}
