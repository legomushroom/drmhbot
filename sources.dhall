let Domains = ./Domains.dhall

let toDomainMap = ./toDomainMap.dhall

in  toDomainMap
      [ { name = "10 Tampa Bay WTSP", domains = Domains.Single "www.wtsp.com" }
      , { name = "ABC News", domains = Domains.Single "abcnews.go.com" }
      , { name = "ABC13", domains = Domains.Single "abc13.com" }
      , { name = "AFP", domains = Domains.Single "www.afp.com" }
      , { name = "AP", domains = Domains.Single "apnews.com" }
      , { name = "Accuweather", domains = Domains.Single "www.accuweather.com" }
      , { name = "Axios", domains = Domains.Single "www.axios.com" }
      , { name = "Axios", domains = Domains.Single "axios.com" }
      , { name = "BBC", domains = Domains.Single "www.bbc.com" }
      , { name = "Bloomberg", domains = Domains.Single "www.bloomberg.com" }
      , { name = "C-SPAN", domains = Domains.Single "www.c-span.org" }
      , { name = "CBNC", domains = Domains.Single "www.cnbc.com" }
      , { name = "CBS Boston", domains = Domains.Single "boston.cbslocal.com" }
      , { name = "CBS Dallas", domains = Domains.Single "dfw.cbslocal.com" }
      , { name = "CBS Denver", domains = Domains.Single "denver.cbslocal.com" }
      , { name = "CBS Miami", domains = Domains.Single "miami.cbslocal.com" }
      , { name = "CBS New York"
        , domains = Domains.Single "newyork.cbslocal.com"
        }
      , { name = "CBS Minnesota"
        , domains = Domains.Single "minnesota.cbslocal.com"
        }
      , { name = "CBS News", domains = Domains.Single "www.cbsnews.com" }
      , { name = "CBS Sports", domains = Domains.Single "www.cbssports.com" }
      , { name = "CNN", domains = Domains.Single "www.cnn.com" }
      , { name = "CNS News", domains = Domains.Single "www.cnsnews.com" }
      , { name = "Chron", domains = Domains.Single "www.chron.com" }
      , { name = "DNYuz", domains = Domains.Single "dnyuz.com" }
      , { name = "Daily Express", domains = Domains.Single "www.express.co.uk" }
      , { name = "Daily Mail", domains = Domains.Single "www.dailymail.co.uk" }
      , { name = "Deadline", domains = Domains.Single "deadline.com" }
      , { name = "Deccan Herald"
        , domains = Domains.Single "www.deccanherald.com"
        }
      , { name = "Deutsche Welle", domains = Domains.Single "www.dw.com" }
      , { name = "ESPN", domains = Domains.Single "www.espn.com" }
      , { name = "Entertainment Tonight"
        , domains = Domains.Single "www.etonline.com"
        }
      , { name = "FOX 5 New York", domains = Domains.Single "www.fox5ny.com" }
      , { name = "Florida Poltics"
        , domains = Domains.Single "floridapolitics.com"
        }
      , { name = "Forth Worth Star-Telegram"
        , domains = Domains.Single "www.star-telegram.com"
        }
      , { name = "Fox News", domains = Domains.Single "www.foxnews.com" }
      , { name = "France 24", domains = Domains.Single "www.france24.com" }
      , { name = "Gallup", domains = Domains.Single "news.gallup.com" }
      , { name = "KTLA", domains = Domains.Single "ktla.com" }
      , { name = "Los Angeles Times"
        , domains = Domains.Single "www.latimes.com"
        }
      , { name = "MarketWatch", domains = Domains.Single "www.marketwatch.com" }
      , { name = "Mediaite", domains = Domains.Single "www.mediaite.com" }
      , { name = "Medical Xpress"
        , domains = Domains.Single "medicalxpress.com"
        }
      , { name = "NBC News", domains = Domains.Single "www.nbcnews.com" }
      , { name = "New York Magazine", domains = Domains.Single "nymag.com" }
      , { name = "New York Post", domains = Domains.Single "nypost.com" }
      , { name = "New York Times", domains = Domains.Single "www.nytimes.com" }
      , { name = "News-Times", domains = Domains.Single "www.newstimes.com" }
      , { name = "Observer", domains = Domains.Single "observer.com" }
      , { name = "Pew Research Center"
        , domains = Domains.Single "www.pewresearch.org"
        }
      , { name = "Politico", domains = Domains.Single "www.politico.com" }
      , { name = "Reason", domains = Domains.Single "reason.com" }
      , { name = "Reuters"
        , domains = Domains.Multiple [ "news.trust.org", "www.reuters.com" ]
        }
      , { name = "SFGATE", domains = Domains.Single "www.sfgate.com" }
      , { name = "Stamford Advocate"
        , domains = Domains.Single "www.stamfordadvocate.com"
        }
      , { name = "Sun Sentinel"
        , domains = Domains.Single "www.sun-sentinel.com"
        }
      , { name = "TMZ", domains = Domains.Single "www.tmz.com" }
      , { name = "Tampa Bay Times"
        , domains = Domains.Single "www.tampabay.com"
        }
      , { name = "The Atlantic"
        , domains = Domains.Single "www.theatlantic.com"
        }
      , { name = "The Daily Beast"
        , domains = Domains.Single "www.thedailybeast.com"
        }
      , { name = "The Guardian"
        , domains = Domains.Single "www.theguardian.com"
        }
      , { name = "The Hill", domains = Domains.Single "thehill.com" }
      , { name = "The Jerusalem Post"
        , domains = Domains.Single "www.jpost.com"
        }
      , { name = "The Scotsman", domains = Domains.Single "www.scotsman.com" }
      , { name = "The Seattle Times"
        , domains = Domains.Single "www.seattletimes.com"
        }
      , { name = "The Sun"
        , domains =
            Domains.Multiple
              [ "www.the-sun.com", "www.the-sun.co.uk", "www.thesun.co.uk" ]
        }
      , { name = "The Washington Post"
        , domains = Domains.Single "www.washingtonpost.com"
        }
      , { name = "The Washington Times"
        , domains = Domains.Single "www.washingtontimes.com"
        }
      , { name = "The Weather Channel", domains = Domains.Single "weather.com" }
      , { name = "Twitter image", domains = Domains.Single "pbs.twimg.om" }
      , { name = "USA Today", domains = Domains.Single "www.usatoday.com" }
      , { name = "VICE", domains = Domains.Single "www.vice.com" }
      , { name = "Wall Street Journal", domains = Domains.Single "www.wsj.com" }
      , { name = "Washington Examiner"
        , domains = Domains.Single "www.washingtonexaminer.com"
        }
      , { name = "Wenatchee World"
        , domains = Domains.Single "www.wenatcheeworld.com"
        }
      , { name = "Wright-Weather"
        , domains = Domains.Single "hp2.wright-weather.com"
        }
      , { name = "Yahoo! News", domains = Domains.Single "news.yahoo.com" }
      , { name = "Times of Israel"
        , domains = Domains.Single "www.timesofisrael.com"
        }
      , { name = "Indianapolis Star"
        , domains = Domains.Single "www.indystar.com"
        }
      , { name = "The Wrap", domains = Domains.Single "www.thewrap.com" }
      , { name = "Dallas Morning News"
        , domains = Domains.Single "www.dallasnews.com"
        }
      ]
