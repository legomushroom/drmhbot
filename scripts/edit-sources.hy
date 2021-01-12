(import argparse)

(import [tabulate [tabulate]])

(defn add-source [name hostname]
  (print name hostname))

(defn remove-source [hostname]
  (print hostname))

(defn list-sources []
  (print (tabulate [["CBS News" "www.cbsnews.com"]]
                   :headers ["Name" "Hostname"]
                   :tablefmt "grid")))

(defmain [&rest args]
  (setv parser (argparse.ArgumentParser :description "Edit the \"sources\" table.")
        subparsers (parser.add-subparsers :help "the sub-command to run"
                                          :dest "subcommand"
                                          :required True)

        add-parser (subparsers.add-parser "add" :help "add a new source")
        remove-parser (subparsers.add-parser "remove" :help "remove a source")
        list-parser (subparsers.add-parser "list" :help "list sources"))

  (add-parser.add-argument "--name" :required True)
  (add-parser.add-argument "--hostname" :required True)

  (remove-parser.add-argument "--hostname" :required True)

  (setv args (parser.parse-args)
        subcommand (. args subcommand))

  (cond
    [(= subcommand "add")
      (add-source (. args name) (. args hostname))]
    [(= subcommand "remove")
      (remove-source (. args hostname))]
    [(= subcommand "list")
      (list-sources)]))
