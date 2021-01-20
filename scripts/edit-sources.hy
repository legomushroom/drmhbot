(import argparse)

(import psycopg2)

(defn add-source [conn source-name host-name]
  (with [conn]
    (with [curs (conn.cursor)]
      (curs.execute "INSERT INTO sources VALUES (%s, %s)" (, source-name host-name)))))

(defn remove-source [conn host-name]
  (with [conn]
    (with [curs (conn.cursor)]
      (curs.execute "DELETE FROM sources WHERE hostname = %s" (, host-name)))))

(defmain [&rest args]
  (setv parser (argparse.ArgumentParser :description "Edit the \"sources\" table.")
        subparsers (parser.add-subparsers :help "the subcommand to run"
                                          :dest "subcommand"
                                          :required True)

        add-parser (subparsers.add-parser "add" :help "add a new source")
        remove-parser (subparsers.add-parser "remove" :help "remove a source"))
  
  (parser.add-argument "--database" :required True)

  (add-parser.add-argument "--name" :required True)
  (add-parser.add-argument "--hostname" :required True)

  (remove-parser.add-argument "--hostname" :required True)

  (setv args (parser.parse-args)
        database-url (. args database)
        subcommand (. args subcommand))
  
  (setv conn (psycopg2.connect database-url))

  (with [conn]
    (cond [(= subcommand "add")
      (add-source conn (. args name) (. args hostname))]
    [(= subcommand "remove")
      (remove-source conn (. args hostname))]))

  (conn.close))
