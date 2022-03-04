#!/usr/bin/env python3

"""
This script is used to regenerate the sources.json file. Do not run it directly;
use the `regenerate_sources.sh` wrapper instead.

To add a new source, add an entry to the sources.json file:

    {
      "Example Source": ["example.com", "example.org"]
    }

NOTE: The new entry's domains **must** be a list, even if the source only has
one domain.
"""

import json
import sys


def main():
    sources = json.load(sys.stdin)

    for source in list(sources.keys()):
        if isinstance(sources[source], list):
            for domain in sources[source]:
                sources[domain] = source

            del sources[source]

    json.dump(sources, sys.stdout, indent=2, sort_keys=True)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
