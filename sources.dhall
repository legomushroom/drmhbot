let Domains = ./Domains.dhall

let toDomainMap = ./toDomainMap.dhall

let source =
      \(name : Text) ->
      \(domain : Text) ->
        { name, domains = Domains.Single domain }

let multiSource =
      \(name : Text) ->
      \(domains : List Text) ->
        { name, domains = Domains.Multiple domains }

in  toDomainMap
      [ source "10 Tampa Bay WTSP" "www.wtsp.com"
      , source "ABC News" "abcnews.go.com"
      , source "ABC13" "abc13.com"
      , source "AFP" "www.afp.com"
      , source "AP" "apnews.com"
      , source "Accuweather" "www.accuweather.com"
      , source "Axios" "www.axios.com"
      , source "Axios" "axios.com"
      , source "BBC" "www.bbc.com"
      , source "Bloomberg" "www.bloomberg.com"
      , source "C-SPAN" "www.c-span.org"
      , source "CBNC" "www.cnbc.com"
      , source "CBS Boston" "boston.cbslocal.com"
      , source "CBS Dallas" "dfw.cbslocal.com"
      , source "CBS Denver" "denver.cbslocal.com"
      , source "CBS Miami" "miami.cbslocal.com"
      , source "CBS New York" "newyork.cbslocal.com"
      , source "CBS Minnesota" "minnesota.cbslocal.com"
      , source "CBS News" "www.cbsnews.com"
      , source "CBS Sports" "www.cbssports.com"
      , source "CNN" "www.cnn.com"
      , source "CNS News" "www.cnsnews.com"
      , source "Chron" "www.chron.com"
      , source "DNYuz" "dnyuz.com"
      , source "Daily Express" "www.express.co.uk"
      , source "Daily Mail" "www.dailymail.co.uk"
      , source "Deadline" "deadline.com"
      , source "Deccan Herald" "www.deccanherald.com"
      , source "Deutsche Welle" "www.dw.com"
      , source "ESPN" "www.espn.com"
      , source "Entertainment Tonight" "www.etonline.com"
      , source "FOX 5 New York" "www.fox5ny.com"
      , source "Florida Poltics" "floridapolitics.com"
      , source "Forth Worth Star-Telegram" "www.star-telegram.com"
      , source "Fox News" "www.foxnews.com"
      , source "France 24" "www.france24.com"
      , source "Gallup" "news.gallup.com"
      , source "KTLA" "ktla.com"
      , source "Los Angeles Times" "www.latimes.com"
      , source "MarketWatch" "www.marketwatch.com"
      , source "Mediaite" "www.mediaite.com"
      , source "Medical Xpress" "medicalxpress.com"
      , source "NBC News" "www.nbcnews.com"
      , source "New York Magazine" "nymag.com"
      , source "New York Post" "nypost.com"
      , source "New York Times" "www.nytimes.com"
      , source "News-Times" "www.newstimes.com"
      , source "Observer" "observer.com"
      , source "Pew Research Center" "www.pewresearch.org"
      , source "Politico" "www.politico.com"
      , source "Reason" "reason.com"
      , source "SFGATE" "www.sfgate.com"
      , source "Stamford Advocate" "www.stamfordadvocate.com"
      , source "Sun Sentinel" "www.sun-sentinel.com"
      , source "TMZ" "www.tmz.com"
      , source "Tampa Bay Times" "www.tampabay.com"
      , source "The Atlantic" "www.theatlantic.com"
      , source "The Daily Beast" "www.thedailybeast.com"
      , source "The Guardian" "www.theguardian.com"
      , source "The Hill" "thehill.com"
      , source "The Jerusalem Post" "www.jpost.com"
      , source "The Scotsman" "www.scotsman.com"
      , source "The Seattle Times" "www.seattletimes.com"
      , source "The Washington Post" "www.washingtonpost.com"
      , source "The Washington Times" "www.washingtontimes.com"
      , source "The Weather Channel" "weather.com"
      , source "Twitter image" "pbs.twimg.om"
      , source "USA Today" "www.usatoday.com"
      , source "VICE" "www.vice.com"
      , source "Wall Street Journal" "www.wsj.com"
      , source "Washington Examiner" "www.washingtonexaminer.com"
      , source "Wenatchee World" "www.wenatcheeworld.com"
      , source "Wright-Weather" "hp2.wright-weather.com"
      , source "Yahoo! News" "news.yahoo.com"
      , source "Times of Israel" "www.timesofisrael.com"
      , source "Indianapolis Star" "www.indystar.com"
      , source "The Wrap" "www.thewrap.com"
      , source "Dallas Morning News" "www.dallasnews.com"
      , multiSource "Reuters" [ "news.trust.org", "www.reuters.com" ]
      , multiSource
          "The Sun"
          [ "www.the-sun.com", "www.the-sun.co.uk", "www.thesun.co.uk" ]
      ]
